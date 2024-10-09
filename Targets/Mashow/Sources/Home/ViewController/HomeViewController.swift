import UIKit
import SnapKit
import Combine
import PhotosUI

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Elements

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .homeBackgroundDefault)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.state.nickname
        label.font = .blankSans(size: 44, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()

    lazy var showLabel: GradientLabel = {
        let view = GradientLabel()
        view.label.text = "SHOW"
        view.label.font = .blankSans(size: 44, weight: .bold)
        view.label.textColor = .white
        return view
    }()

    lazy var viewToggleStackView: ViewToggleStackView = {
        let view = ViewToggleStackView()
        return view
    }()

    lazy var drinkCardView: CardView = {
        let view = CardView()
        return view
    }()
    
    lazy var listTypeRecordViewController: ListTypeRecordViewController = {
        let view = ListTypeRecordViewController()
        return view
    }()
    
    lazy var recordButton: AddButton = {
        let button = AddButton()
        button.onTap = { [weak self] in
            guard let self else { return }
            self.didTapRecordButton()
        }
        return button
    }()
    
    lazy var aiButton: AIButton = {
        let button = AIButton()
        button.onTap = { [weak self] in
            guard let self else { return }
            self.didTapAIButton()
        }
        return button
    }()

    lazy var myPageButton: CircularButton = {
        let button = CircularButton()
        button.setImage(
            UIImage(
                systemName: "person.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)),
            for: .normal)
        button.tintColor = .white
        button.backgroundColor = .hex("F2F2F2").withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didTapMyPageButton), for: .touchUpInside)

        return button
    }()
    
    // Loading indicator
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.color = .white
        loadingView.startAnimating()
        loadingView.isHidden = true // Initially hidden
        return loadingView
    }()

    // Overlay view to block user interaction during loading
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.01) // Semi-transparent background
        view.isHidden = true // Initially hidden
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSubViewController()
        setupConstraints()
        setupSubViewAction()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - View setup

    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(showLabel)
//        view.addSubview(viewToggleStackView)
        view.addSubview(drinkCardView)
        view.addSubview(recordButton)
        view.addSubview(aiButton)
        view.addSubview(myPageButton)
    }
    
    private func setupSubViewController() {
        addChild(listTypeRecordViewController)
        view.addSubview(listTypeRecordViewController.view)
        
        // For z index
        view.addSubview(overlayView)
        view.addSubview(loadingView)
    }

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view).offset(20)
        }
        nicknameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        showLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
        }
        showLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        showLabel.setColors([
            .hex("C6CEA5").withAlphaComponent(0.7),
            .hex("C5A7A7").withAlphaComponent(0.7),
            .hex("47525A")
        ])

//        viewToggleStackView.snp.makeConstraints { make in
//            make.top.equalTo(showLabel.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(194)
//            make.height.equalTo(34)
//        }
        
        drinkCardView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(showLabel.snp.bottom).offset(26)
            make.leading.equalTo(view).offset(30)
            make.trailing.equalTo(view).inset(30)
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
        }
        
        listTypeRecordViewController.view.snp.makeConstraints { make in
            make.top.equalTo(showLabel.snp.bottom).offset(26)
            make.leading.equalTo(view).offset(24)
            make.trailing.equalTo(view).inset(24)
            make.bottom.equalTo(recordButton.snp.top).offset(-25)
        }
        
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        aiButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.equalTo(recordButton.snp.right).offset(20)
            make.height.equalTo(35)
            make.width.equalTo(35)
        }
        
        myPageButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.height.width.equalTo(32)
            make.trailing.equalTo(view).inset(20)
        }
        
        loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.center.equalToSuperview()
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSubViewAction() {
        viewToggleStackView.onTapCardView = { [weak self] in
            self?.showAlert(title: "Coming Soon!", message: "곧 추가됩니다")
        }
    }
    
    private func showNotDeterminedView() {
        drinkCardView.isHidden = true
        listTypeRecordViewController.view.isHidden = true
    }
    
    private func showEmptyStateView() {
        drinkCardView.isHidden = false
        listTypeRecordViewController.view.isHidden = true
    }
    
    private func showMiniCardListView(with drinkTypeList: [DrinkType]) {
        drinkCardView.isHidden = true
        listTypeRecordViewController.configure(
            nickname: viewModel.state.nickname,
            userId: viewModel.state.userId,
            availableDrinkTypes: drinkTypeList,
            refreshHomeWhenSubmitted: { [weak self] in
                guard let self else { return }
                try await self.viewModel.refresh()
            }
        )
        listTypeRecordViewController.view.isHidden = false
    }
    
    private func showGPTResultView(with spritInfo: SpiritGPT.Spirit) {
        guard let drinkType = DrinkType(rawValue: spritInfo.type) else {
            showErrorAlert(title: "라벨 인식 실패",
                           message: "라벨을 인식할 수 없습니다. 라벨이 더 선명하게 보이는 이미지를 사용해보세요.")
            return
        }
        
        let vc = DrinkSelectionViewController(
            viewModel: .init(
                state: .init(
                    initialDrinkType: drinkType,
                    drinkName: spritInfo.name),
                action: .init(
                    onSubmitted: { [weak self] in
                        guard let self else { return }
                        try await self.viewModel.refresh()
                    }))
        )
        
        show(vc, sender: nil)
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.state.records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self else { return }
                
                guard let records else {
                    self.showNotDeterminedView()
                    return
                }
                
                if records.isEmpty {
                    self.showEmptyStateView()
                } else {
                    self.showMiniCardListView(with: Array(records))
                }
            }
            .store(in: &cancellables)
        
        viewModel.state.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                
                self.showErrorAlert()
            }
            .store(in: &cancellables)
        
        viewModel.state.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.loadingView.isHidden = !isLoading
                self.overlayView.isHidden = !isLoading // Show/hide overlay based on loading state
            }
            .store(in: &cancellables)
        
        viewModel.state.gptResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let spirit):
                    self.showGPTResultView(with: spirit)
                    
                case .failure(let error):
                    if let gptError = error as? SpiritGPT.GPTError {
                        switch gptError {
                        case .cannotRecognize:
                            self.showErrorAlert(title: "라벨 인식 실패",
                                                message: "라벨을 인식할 수 없습니다. 라벨이 더 선명하게 보이는 이미지를 사용해보세요.")
                        default:
                            self.showErrorAlert(title: "서비스 이용 불가",
                                                message: "현재 서비스를 사용할 수 없습니다. 잠시 후 다시 시도하시거나 문제가 지속되면 제작자에게 문의해주세요.")
                        }
                    } else {
                        self.showErrorAlert(title: "처리 중 오류 발생",
                                            message: "문제가 발생했습니다. 잠시 후 다시 시도하시거나 문제가 지속되면 제작자에게 문의해주세요.")
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Action

extension HomeViewController {
    @objc private func didTapRecordButton() {
        Haptic.buttonTap()
        
        let vc = DrinkSelectionViewController(
            viewModel: .init(
                state: .init(
                    initialDrinkType: nil),
                action: .init(
                    onSubmitted: { [weak self] in
                        guard let self else { return }
                        try await self.viewModel.refresh()
                    }))
        )
        
        show(vc, sender: nil)
    }
    
    @objc private func didTapAIButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func didTapMyPageButton() {
        Haptic.buttonTap()
        
        let vc = MyPageViewController(
            viewModel: MyPageViewModel(
                state: .init(accessTokenSubject: viewModel.state.accessToken)))
        
        show(vc, sender: nil)
    }
}

// MARK: - Delegate
extension HomeViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil) // Picker 닫기
        
        // 선택한 사진이 있을 경우
        if let firstResult = results.first {
            let itemProvider = firstResult.itemProvider
            
            // 이미지가 있는지 확인
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    guard let selectedImage = image as? UIImage else {
                        return
                    }
                    
                    Task { try await self.viewModel.askGPT(with: selectedImage) }
                }
            }
        }
    }
}

import SwiftUI
#Preview {
    HomeViewController.preview {
        let vc = HomeViewController()
        vc.viewModel = .init(state: .init(nickname: "Temp한글",
                                          userId: 1,
                                          accessToken: .init(nil)))
        vc.viewModel.state.records.send([.soju, .beer, .wine])
        return vc
    }
}
