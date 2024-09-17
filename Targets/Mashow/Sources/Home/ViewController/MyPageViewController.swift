//
//  MyPageViewController.swift
//  Mashow
//
//  Created by Kai Lee on 9/17/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

import Combine
class MyPageViewModel {
    private let networkManager: NetworkManager<API>
    let state: State
    
    struct State {
        let accessTokenSubject: CurrentValueSubject<String?, Never>
        
        // UX Related
        let isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    }
    
    init(state: State, networkManager: NetworkManager<API> = Environment.network) {
        self.state = state
        self.networkManager = networkManager
    }
    
    func logout() {
        state.accessTokenSubject.send(nil)
    }
    
    func deleteAccount() async throws {
        state.isLoading.send(true)
        defer { self.state.isLoading.send(false) }
        
        if let accessToken = state.accessTokenSubject.value {
            try await networkManager.request(
                .user(.withdraw(accessToken: accessToken)))
            state.accessTokenSubject.send(nil)
        }
    }
}

class MyPageViewController: UIViewController {
    
    let viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.style = .medium
        loadingView.color = .white
        
        loadingView.startAnimating()
        return loadingView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        return tableView
    }()

    // My Page 섹션과 항목 데이터
    let myPageSections: [MyPageSection] = [
        MyPageSection(header: "계정", items: [
            MyPageItem(title: "닉네임 변경", action: .changeNickname)
        ]),
        MyPageSection(header: "기타", items: [
            MyPageItem(title: "로그아웃", action: .logout),
            MyPageItem(title: "계정 삭제", action: .deleteAccount)
        ])
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }

    // MARK: - Setup Methods

    private func setupViews() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        view.addSubview(loadingView)
    }

    private func setupConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        hideLoadingView()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "마이페이지"
    }
    
    private func bind() {
        viewModel.state.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                
                if isLoading {
                    self.showLoadingView()
                } else {
                    self.hideLoadingView()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension MyPageViewController {
    func showLoadingView() {
        loadingView.isHidden = false
    }
    
    func hideLoadingView() {
        loadingView.isHidden = true
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageSections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return myPageSections[section].header
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 헤더 스타일 설정
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = .pretendard(size: 16, weight: .bold)
            headerView.textLabel?.textColor = .label
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = myPageSections[indexPath.section].items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else {
            return UITableViewCell()
        }
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = myPageSections[indexPath.section].items[indexPath.row]
        handleAction(for: item.action)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions Handling

extension MyPageViewController {
    private func handleAction(for action: MyPageAction) {
        switch action {
        case .changeNickname:
            showChangeNicknameAlert()
        case .logout:
            showLogoutConfirmation()
        case .deleteAccount:
            showDeleteAccountConfirmation()
        }
    }

    private func showChangeNicknameAlert() {
        let alert = UIAlertController(title: "닉네임 변경", message: "새로운 닉네임을 입력하세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "닉네임"
            textField.autocapitalizationType = .none
            textField.clearButtonMode = .whileEditing
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let nickname = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nickname.isEmpty {
                // 닉네임 변경 처리 로직
                self.changeNickname(to: nickname)
            } else {
                // 빈 닉네임 처리
                self.showErrorAlert(message: "닉네임을 입력해 주세요.")
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }

    private func changeNickname(to newNickname: String) {
        let successAlert = UIAlertController(
            title: "완료",
            message: "닉네임이 변경되었습니다.",
            preferredStyle: .alert)
        
        successAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(successAlert, animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "로그아웃",
            message: "정말로 로그아웃 하시겠습니까?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(
            title: "로그아웃",
            style: .destructive,
            handler: { [weak self] _ in
                self?.viewModel.logout()
            }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAccountConfirmation() {
        let alert = UIAlertController(
            title: "계정 삭제",
            message: "정말로 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "삭제",
            style: .destructive,
            handler: { [weak self] _ in
                Task {
                    do {
                        try await self?.viewModel.deleteAccount()
                    } catch {
                        self?.showErrorAlert()
                    }
                }
            }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension MyPageViewController {
    // MARK: - Models

    struct MyPageSection {
        let header: String
        let items: [MyPageItem]
    }

    struct MyPageItem {
        let title: String
        let action: MyPageAction
        var accessoryType: UITableViewCell.AccessoryType {
            return .disclosureIndicator
        }
    }

    enum MyPageAction {
        case changeNickname
        case logout
        case deleteAccount
    }

}

// MARK: - Placeholder View Controllers

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "프로필"
    }
}

import SwiftUI
#Preview {
    MyPageViewController.preview()
}
