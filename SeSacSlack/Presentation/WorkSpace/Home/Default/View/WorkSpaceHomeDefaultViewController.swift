//
//  WorkSpaceHomeInitViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa


class WorkSpaceHomeInitViewController: BaseViewController {
    let testData = [
        ["일반","채널1","채널2","채널3","채널4","채널5","채널6","채널7","채널8","채널9","채널추가"],
        ["사람1","사람2","사람3","사람4","사람5","사람6","사람7","사람8","사람9","사람10","새 메시지 시작"],
        ["팀원추가"]
    ]
    
    enum Section: Int, Hashable, CaseIterable {
        case channel
        case directmessage
        case addMember
        
        var title: String {
            switch self {
            case .channel:
                return "채널"
            case .directmessage:
                return "다이렉트 메시지"
            case .addMember:
                return "팀원추가"
            }
        }
    }
    
    struct Item: Hashable {
        let title: String?
        let hasChildren: Bool
        init( title: String? = nil, hasChildren: Bool = false) {
            self.title = title
            self.hasChildren = hasChildren
        }
        private let identifier = UUID()
    }
    
    let workSpaceNaviBar = WorkSpaceProfileView()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots()
        setUpBackgroundColors()
        
    }
    
    override func setHierarchy() {
        view.addSubview(workSpaceNaviBar)
    }
    override func setConstraint() {
        workSpaceNaviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(46)
        }
    }
    private func setUpBackgroundColors(){
        view.backgroundColor = Colors.backgroundSecondar.color
        workSpaceNaviBar.backgroundColor = Colors.backgroundSecondar.color
        collectionView.backgroundColor = Colors.backgroundSecondar.color
    }
    
}

extension WorkSpaceHomeInitViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(workSpaceNaviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// - Tag: CreateFullLayout
    /// - Returns: <#description#>
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            var containerGroup: NSCollectionLayoutGroup!
            //            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .channel:
                containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(44)),
                    subitem: item, count: 1)
            case .directmessage:
                containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(56)),
                    subitem: item, count: 1)
            case .addMember:
                containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(44)),
                    subitem: item, count: 1)
                
            }
            let section = NSCollectionLayoutSection(group: containerGroup)
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    
    func createOutlineHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, title) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            content.textProperties.font = Font.title2.fontWithLineHeight()
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header, tintColor:  Colors.brandBlack.color))]
        }
    }
    
    func createOutlineCellRegistration() -> UICollectionView.CellRegistration<IconImageCollectionViewCell, String> {
        return UICollectionView.CellRegistration<IconImageCollectionViewCell, String> { (cell, indexPath, text) in
            if let section = Section(rawValue: indexPath.section){
                switch section {
                case .channel:
                    cell.setupchnnal(title: text)
                    cell.setupChatCount(2)
                    break
                case .directmessage:
                    cell.setupDM(image: nil, title: text)
                    cell.setupChatCount(5)
                    break
                case .addMember:
                    break
                }
                let itemCount = self.collectionView.numberOfItems(inSection: indexPath.section)
                print("\(indexPath.section)섹션 아이템 갯수 ",itemCount)
                if indexPath.item == itemCount - 1 {
                    cell.setupLast(title: text)
                    cell.setupChatCount(nil)
                }
            }
        }
    }
    
    
    /// - Tag: DequeueCells
    func configureDataSource() {
        // create registrations up front, then choose the appropriate one to use in the cell provider
        let outlineHeaderCellRegistration = createOutlineHeaderCellRegistration()
        let outlineCellRegistration = createOutlineCellRegistration()
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .channel,.addMember,.directmessage:
                if item.hasChildren {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineHeaderCellRegistration, for: indexPath, item: item.title!)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineCellRegistration, for: indexPath, item: item.title!)
                }
            }
        }
    }
    
    /// - Tag: SectionSnapshot
    func applyInitialSnapshots() {
        // set the order for our sections
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        for category in sections {
            //  outlines
            var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            
            var rootItem: Item
            if case Section.addMember = category {
                rootItem = Item(title: String(describing: category.title), hasChildren: false)
            } else {
                rootItem = Item(title: String(describing: category.title), hasChildren: true)
            }
            
            outlineSnapshot.append([rootItem])
            let outlineItems = testData[category.rawValue].map { Item(title:$0) }
            outlineSnapshot.append(outlineItems, to: rootItem)
            dataSource.apply(outlineSnapshot, to: category, animatingDifferences: false)
        }
        
    }
}


