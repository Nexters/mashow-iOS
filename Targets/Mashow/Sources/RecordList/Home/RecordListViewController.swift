//
//  RecordListViewController.swift
//  MashowKitTests
//
//  Created by Kai Lee on 8/29/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit
import Combine

class RecordListViewController: UIViewController {
    // MARK: - Properties
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<Category, RecordCellInformation>
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSourceType!
    private var viewModel: RecordListViewModel
    
    init(viewModel: RecordListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .backgroundDefault)
        imageView.contentMode = .scaleAspectFill
        
        // Add a dimming effect
        let dimmingView = UIView()
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.5
        
        imageView.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return imageView
    }()
    
    lazy var titleButton: UIButton = {
        let titleButton = UIButton(type: .system)

        var config = UIButton.Configuration.plain()
        config.title = ""
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))

        // Adjust the spacing between the title and the image
        config.imagePadding = 6.0

        // Set the button configuration
        titleButton.configuration = config
        titleButton.configurationUpdateHandler = { button in
            button.configuration?.baseForegroundColor = .white
            button.configuration?.attributedTitle?.font = .pretendard(size: 16, weight: .semibold)
        }

        // Add an arrow image to the button
        let arrowImage = UIImage(systemName: "chevron.down",
                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))
        titleButton.setImage(arrowImage, for: .normal)
        titleButton.semanticContentAttribute = .forceRightToLeft
        titleButton.tintColor = .white

        // Create a menu with options
        let menuItems = viewModel.state.fetchableDrinkTypes.map { type in
            UIAction(title: type.korean) { [weak self] _ in
                guard let self else { return }
                
                Task {
                    do {
                        self.viewModel.updateCurrentDrinkType(with: type)
                        try await self.viewModel.updateRecords(with: type)
                    } catch {
                        self.showErrorAlert()
                    }
                }
            }
        }
        
        // Attach the menu to the button
        titleButton.menu = UIMenu(title: "", children: menuItems)
        titleButton.showsMenuAsPrimaryAction = true
        
        titleButton.snp.makeConstraints { make in
            make.width.equalTo(150)
        }
        return titleButton
    }()
    
    lazy var recordButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("기록하기", for: .normal)
        button.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        return button
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.color = .white
        loadingView.startAnimating()
        return loadingView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        applySnapshot(recordStat: nil, records: [])
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        bind()
        
        let drinkTypeToBeShown = viewModel.currentDrinkType
        viewModel.updateCurrentDrinkType(with: drinkTypeToBeShown)
        Task {
            do {
                try await viewModel.updateRecords(with: drinkTypeToBeShown)
            } catch {
                showErrorAlert()
            }
        }
    }
    
    // MARK: - Bind
    
    private var cancellables = Set<AnyCancellable>()
    
    private func bind() {
        viewModel.state.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.isHidden = true
                    
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.state.currentDrinkType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] drinkType in
                guard let self else { return }
                self.titleButton.setTitle(drinkType.korean, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.state.records.zip(viewModel.state.recordStat)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records, recordStat in
                guard let self else { return }
                // Prepare fade in
                self.collectionView.alpha = 0.0

                self.applySnapshot(recordStat: nil, records: []) // To reset all scroll positions
                self.applySnapshot(recordStat: recordStat, records: records)

                // Fade in
                UIView.animate(withDuration: 0.15) {
                    self.collectionView.alpha = 1.0
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(recordButton)
        view.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        recordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = titleButton
    }
}

extension RecordListViewController {
    struct RecordCellInformation: Hashable, Equatable {
        enum RecordType: Hashable {
            case overview(RecordStat)
            case record
        }

        let id: UUID
        let date: Date?
        let names: [String]?
        let recordType: RecordType
        
        static func == (lhs: RecordCellInformation, rhs: RecordCellInformation) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    struct Category: Hashable {
        let year: Int
        let month: Int
        let totalRecordCount: Int
        let stringInfo: String
        
        init(year: Int, month: Int, totalRecordCount: Int) {
            self.year = year
            self.month = month
            self.totalRecordCount = totalRecordCount
            self.stringInfo = "\(year)년 \(month)월"
        }
    }
}

// MARK: - UICollectionViewDelegate

extension RecordListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // Trigger pagination when the user scrolls near the bottom
        if offsetY > contentHeight - height - 100 {
            Task {
                do {
                    try await viewModel.fetchNextPage()
                } catch {
                    showErrorAlert()
                }
            }
        }
    }
}

// MARK: - CollectionView related

extension RecordListViewController {
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        // Register the custom cells and supplementary views
        collectionView.register(RecordCell.self,
                                forCellWithReuseIdentifier: RecordCell.reuseIdentifier)
        collectionView.register(OverviewCell.self,
                                forCellWithReuseIdentifier: OverviewCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        
        // Configure the refresh control
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupDataSource() {
        dataSource = DataSourceType(collectionView: collectionView) { [weak self] (collectionView, indexPath, record) -> UICollectionViewCell? in
            guard let self else { return nil }
            
            switch record.recordType {
            case .overview(let recordStat):
                guard let headerCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OverviewCell.reuseIdentifier,
                    for: indexPath
                ) as? OverviewCell
                else {
                    return nil
                }
                headerCell.configure(
                    title: "\(self.viewModel.state.nickname)님의 이번달",
                    drinkType: "\(self.viewModel.currentDrinkType.korean)",
                    percentage: "\(recordStat.frequencyPercentage)%",
                    buttons: recordStat.names)
                
                return headerCell
                
            case .record:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecordCell.reuseIdentifier,
                    for: indexPath
                ) as? RecordCell
                else {
                    return nil
                }
                
                cell.configure(with: [record], onTap: {
                    let vc = RecordDetailViewController()                    
                    self.show(vc, sender: nil)
                })
                return cell
            }
        }

        // Configure the section header view
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderView else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.configure(with: section.stringInfo, count: section.totalRecordCount)
            return headerView
        }
    }
    
    private func applySnapshot(recordStat: RecordStat?, records: [RecordCellInformation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Category, RecordCellInformation>()
        
        if let recordStat {
            let overviewSection = Category(year: -1, month: -1, totalRecordCount: -1)
            let item = RecordCellInformation(id: UUID(), date: nil, name: nil, recordType: .overview(recordStat))
            
            snapshot.appendSections([overviewSection])
            snapshot.appendItems([item], toSection: overviewSection)
        }
        
        let groupedRecords = groupRecordsByMonth(records: records)
        
        // Sort the sections by date, ensuring the latest one comes first
        let sortedCategories = groupedRecords.keys.sorted {
            // Compare year first, and if equal, compare month
            if $0.year == $1.year {
                return $0.month > $1.month
            }
            return $0.year > $1.year
        }
        
        for category in sortedCategories {
            if var recordsForMonth = groupedRecords[category] {
                recordsForMonth.sort { $0.date ?? Date() > $1.date ?? Date() }
                if !snapshot.sectionIdentifiers.contains(category) {
                    snapshot.appendSections([category])
                }
                snapshot.appendItems(recordsForMonth, toSection: category)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func groupRecordsByMonth(records: [RecordCellInformation]) -> [Category: [RecordCellInformation]] {
        var groupedRecords = [Category: [RecordCellInformation]]()
        
        for record in records {
            guard let date = record.date else {
                continue
            }
            
            let components = Calendar.current.dateComponents([.year, .month], from: date)
            guard let year = components.year, let month = components.month else { continue }
            
            let category = Category(year: year, month: month, totalRecordCount: 0)
            
            // Append the record to the appropriate category, creating a new array if necessary
            groupedRecords[category, default: []].append(record)
        }
        
        // FIXME: 나중에 서버에서 개수를 직접 받아오게 될지도
        // Update the totalRecordCount for each category
        for (category, records) in groupedRecords {
            let updatedCategory = Category(year: category.year, month: category.month, totalRecordCount: records.count)
            groupedRecords[updatedCategory] = records
            groupedRecords.removeValue(forKey: category)
        }
        
        return groupedRecords
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize: NSCollectionLayoutSize
            let groupSize: NSCollectionLayoutSize
            let item: NSCollectionLayoutItem
            let group: NSCollectionLayoutGroup
            let section: NSCollectionLayoutSection
            
            if sectionIndex == 0 {
                // Layout for the first cell (overview cell)
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(140))
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 35, trailing: 0)
            } else {
                // Layout for regular records
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 11)
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.25),
                                                   heightDimension: .estimated(100))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                // Add a header for the section
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .top)
                section.boundarySupplementaryItems = [header]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
            }
            
            return section
        }
    }
}

// MARK: - Actions

extension RecordListViewController {
    @objc private func didPullToRefresh() {
        Task {
            do {
                refreshControl.beginRefreshing()
                try await viewModel.updateRecords(with: viewModel.state.currentDrinkType.value)
            } catch {
                showErrorAlert()
            }
        }
    }
    
    @objc private func didTapRecordButton() {
        let vc = DrinkSelectionViewController(
            viewModel: .init(
                state: .init(),
                action: .init(
                    onSubmitted: { [weak self] in
                        guard let self else { return }
                        try await self.viewModel.action.refreshHomeWhenSubmitted()
                    }))
        )
        
        show(vc, sender: nil)
    }
}

import SwiftUI
#Preview {
    RecordListViewController.preview()
}
