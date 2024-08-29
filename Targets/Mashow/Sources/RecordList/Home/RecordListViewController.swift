//
//  RecordListViewController.swift
//  MashowKitTests
//
//  Created by Kai Lee on 8/29/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import SnapKit

class RecordListViewController: UIViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<Category, Record>
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: DataSourceType!
    private var records: [Record] = [
        Record(id: UUID(), date: nil, type: nil, recordType: .overview),
        Record(id: UUID(), date: "2024.07.22", type: "진로", recordType: .record),
        Record(id: UUID(), date: "2024.07.24", type: "참이슬", recordType: .record),
        Record(id: UUID(), date: "2024.07.31", type: "참이슬", recordType: .record),
        Record(id: UUID(), date: "2024.07.10", type: "참이슬", recordType: .record),
        Record(id: UUID(), date: "2024.07.30", type: "참이슬", recordType: .record),
        Record(id: UUID(), date: "2024.05.30", type: "참이슬", recordType: .record),
        Record(id: UUID(), date: "2024.06.30", type: "참이슬", recordType: .record),
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        applySnapshot()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(recordButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        recordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func createButton(title: String, count: Int) -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("\(title) \(count)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.hex("2F2F2F").withAlphaComponent(0.7)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
    
    // MARK: - UI Elements
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .loginBackground)
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
    
    lazy var recordButton: UIButton = {
        let button = BlurredButton()
        button.setTitle("기록하기", for: .normal)
        return button
    }()
}

extension RecordListViewController {
    struct Record: Hashable {
        enum RecordType {
            case overview
            case record
        }

        let id: UUID
        let date: String?
        let type: String?
        let recordType: RecordType
    }
    struct Category: Hashable {
        let year: Int
        let month: Int
        let stringInfo: String
        
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
            self.stringInfo = "\(year)년 \(month)월"
        }
    }
}

// MARK: - UICollectionViewDelegate

extension RecordListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection if needed
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
    }
    
    private func setupDataSource() {
        dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, record) -> UICollectionViewCell? in
            switch record.recordType {
            case .overview:
                guard let headerCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OverviewCell.reuseIdentifier,
                    for: indexPath
                ) as? OverviewCell
                else {
                    return nil
                }
                headerCell.configure(
                    title: "MYUNG님의 이번달",
                    concentration: "혈중 소주 농도",
                    percentage: "41%",
                    buttons: [("처음처럼", 4), ("참이슬", 2), ("진로", 1)]
                )
                return headerCell
                
            case .record:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecordCell.reuseIdentifier,
                    for: indexPath
                ) as? RecordCell
                else {
                    return nil
                }
                cell.configure(with: record)
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
            headerView.configure(with: section.stringInfo)
            return headerView
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Category, Record>()
        
        let firstSection = Category(year: -1, month: -1)
        snapshot.appendSections([firstSection])
        snapshot.appendItems(records, toSection: firstSection)
        
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
                recordsForMonth.sort { $0.date ?? "" > $1.date ?? "" }
                snapshot.appendSections([category])
                snapshot.appendItems(recordsForMonth, toSection: category)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func groupRecordsByMonth(records: [Record]) -> [Category: [Record]] {
        var groupedRecords = [Category: [Record]]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        for record in records {
            guard let date = dateFormatter.date(from: record.date ?? "") else { continue }
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let category = Category(year: year, month: month)
            
            // Check if category already exists in groupedRecords
            if let existingCategory = groupedRecords.keys.first(where: { $0 == category }) {
                groupedRecords[existingCategory]?.append(record)
            } else {
                groupedRecords[category] = [record]
            }
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
                                                   heightDimension: .estimated(230))
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
            } else {
                // Layout for regular records
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(0.9))
                item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 11)
                
                groupSize = NSCollectionLayoutSize(widthDimension: .absolute(360),
                                                   heightDimension: .absolute(210))
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
            }
            
            // Apply consistent content insets for all sections
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
            
            return section
        }
    }
}

import SwiftUI
#Preview {
    RecordListViewController.preview()
}
