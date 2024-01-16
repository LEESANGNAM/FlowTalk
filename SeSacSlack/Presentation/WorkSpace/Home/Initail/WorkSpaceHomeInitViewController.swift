//
//  WorkSpaceHomeInitViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa

enum testsection: Int {
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

struct Emoji: Hashable {

    enum Category: Int,CaseIterable, CustomStringConvertible {
        case channel = 0
        case directmessage
        case addMember
    }
    
    let text: String
    let title: String
    let category: Category
    private let identifier = UUID()
}

extension Emoji.Category {
    
    var description: String {
        switch self {
        case .channel:
            return "채널"
        case .directmessage:
            return "다이렉트 메시지"
        case .addMember:
            return "팀원추가"
//        case .recents: return "Recents"
//        case .smileys: return "Smileys"
//        case .nature: return "Nature"
//        case .food: return "Food"
//        case .activities: return "Activities"
//        case .travel: return "Travel"
//        case .objects: return "Objects"
//        case .symbols: return "Symbols"
        }
    }
    
//    var emojis: [String] {
//        switch self {
//        case .channel:
//            return  ["일반","채널1","채널2","채널3","채널4","채널5","채널6","채널7","채널8","채널9","채널추가"]
//        case .directmessage:
//            return ["사람1","사람2","사람3","사람4","사람5","사람6","사람7","사람8","사람9","사람10","사람11"]
//        case .addMember:
//            return ["팀원추가"]
////        case .recents:
////            return [
////                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self),
////                Emoji(text: "🥃", title: "Whiskey", category: self),
////                Emoji(text: "😎", title: "Cool", category: self),
////                Emoji(text: "🏔", title: "Mountains", category: self),
////                Emoji(text: "⛺️", title: "Camping", category: self),
////                Emoji(text: "⌚️", title: " Watch", category: self),
////                Emoji(text: "💯", title: "Best", category: self),
////                Emoji(text: "✅", title: "LGTM", category: self)
////            ]
////
////        case .smileys:
////            return [
////                Emoji(text: "😀", title: "Happy", category: self),
////                Emoji(text: "😂", title: "Laughing", category: self),
////                Emoji(text: "🤣", title: "Rolling on the floor laughing", category: self)
////            ]
////            
////        case .nature:
////            return [
////                Emoji(text: "🦊", title: "Fox", category: self),
////                Emoji(text: "🐝", title: "Bee", category: self),
////                Emoji(text: "🐢", title: "Turtle", category: self)
////            ]
////            
////        case .food:
////            return [
////                Emoji(text: "🥃", title: "Whiskey", category: self),
////                Emoji(text: "🍎", title: "Apple", category: self),
////                Emoji(text: "🍑", title: "Peach", category: self)
////            ]
////        case .activities:
////            return [
////                Emoji(text: "🏈", title: "Football", category: self),
////                Emoji(text: "🚴‍♀️", title: "Cycling", category: self),
////                Emoji(text: "🎤", title: "Singing", category: self)
////            ]
////
////        case .travel:
////            return [
////                Emoji(text: "🏔", title: "Mountains", category: self),
////                Emoji(text: "⛺️", title: "Camping", category: self),
////                Emoji(text: "🏖", title: "Beach", category: self)
////            ]
////
////        case .objects:
////            return [
////                Emoji(text: "🖥", title: "iMac", category: self),
////                Emoji(text: "⌚️", title: " Watch", category: self),
////                Emoji(text: "📱", title: "iPhone", category: self)
////            ]
////
////        case .symbols:
////            return [
////                Emoji(text: "❤️", title: "Love", category: self),
////                Emoji(text: "☮️", title: "Peace", category: self),
////                Emoji(text: "💯", title: "Best", category: self)
////            ]
//
//        }
//    }
}


class WorkSpaceHomeInitViewController: BaseViewController {
    let testData = [
    ["일반","채널1","채널2","채널3","채널4","채널5","채널6","채널7","채널8","채널9","채널추가"],
    ["사람1","사람2","사람3","사람4","사람5","사람6","사람7","사람8","사람9","사람10","사람11"],
    ["팀원추가"]
    ]
    
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case test
        
        var description: String {
            switch self {
            case .test: return "test"
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
    
    var hiddenSections = Set<Int>()
    let workSpaceNaviBar = WorkSpaceProfileView()
//    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var starredEmojis = Set<Item>()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots()
    }
    
    
   
    
    override func setHierarchy() {
        view.addSubview(workSpaceNaviBar)
//        view.addSubview(tableView)
    }
    override func setConstraint() {
        workSpaceNaviBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(46)
        }
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(workSpaceNaviBar.snp.bottom)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    
}

extension WorkSpaceHomeInitViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
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
        
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            // orthogonal scrolling section of images
//            if sectionKind == .recents {
//                
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 10
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
            // outline
//            } else if sectionKind == .outline {
                section = NSCollectionLayoutSection.list(using: .init(appearance: .sidebar), layoutEnvironment: layoutEnvironment)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

//            // list
//            } else if sectionKind == .list {
//                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//                configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
//                    guard let self = self else { return nil }
//                    guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
//                    return self.leadingSwipeActionConfigurationForListCellItem(item)
//                }
//                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
//            } else {
//                fatalError("Unknown section!")
//            }
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
//            if let coordinator = self.transitionCoordinator {
//                coordinator.animate(alongsideTransition: { context in
//                    self.collectionView.deselectItem(at: indexPath, animated: true)
//                }) { (context) in
//                    if context.isCancelled {
//                        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
//                    }
//                }
//            } else {
//                self.collectionView.deselectItem(at: indexPath, animated: animated)
//            }
//        }
//    }
    
//    func accessoriesForListCellItem(_ item: Item) -> [UICellAccessory] {
//        let isStarred = self.starredEmojis.contains(item)
//        var accessories = [UICellAccessory.disclosureIndicator()]
//        if isStarred {
//            let star = UIImageView(image: UIImage(systemName: "star.fill"))
//            accessories.append(.customView(configuration: .init(customView: star, placement: .trailing())))
//        }
//        return accessories
//    }
    
//    func leadingSwipeActionConfigurationForListCellItem(_ item: Item) -> UISwipeActionsConfiguration? {
//        let isStarred = self.starredEmojis.contains(item)
//        let starAction = UIContextualAction(style: .normal, title: nil) {
//            [weak self] (_, _, completion) in
//            guard let self = self else {
//                completion(false)
//                return
//            }
//            
//            // Don't check again for the starred state. We promised in the UI what this action will do.
//            // If the starred state has changed by now, we do nothing, as the set will not change.
//            if isStarred {
//                self.starredEmojis.remove(item)
//            } else {
//                self.starredEmojis.insert(item)
//            }
//            
//            // Reconfigure the cell of this item
//            // Make sure we get the current index path of the item.
//            if let currentIndexPath = self.dataSource.indexPath(for: item) {
//                if let cell = self.collectionView.cellForItem(at: currentIndexPath) as? UICollectionViewListCell {
//                    UIView.animate(withDuration: 0.2) {
//                        cell.accessories = self.accessoriesForListCellItem(item)
//                    }
//                }
//            }
//            
//            completion(true)
//        }
//        starAction.image = UIImage(systemName: isStarred ? "star.slash" : "star.fill")
//        starAction.backgroundColor = .systemBlue
//        return UISwipeActionsConfiguration(actions: [starAction])
//    }
    
//    func createGridCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Emoji> {
//        return UICollectionView.CellRegistration<UICollectionViewCell, Emoji> { (cell, indexPath, emoji) in
//            var content = UIListContentConfiguration.cell()
//            content.text = emoji.text
//            content.textProperties.font = .boldSystemFont(ofSize: 38)
//            content.textProperties.alignment = .center
//            content.directionalLayoutMargins = .zero
//            cell.contentConfiguration = content
//            var background = UIBackgroundConfiguration.listPlainCell()
//            background.cornerRadius = 8
//            background.strokeColor = .systemGray3
//            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
//            cell.backgroundConfiguration = background
//        }
//    }
    
    func createOutlineHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, title) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
    }
    
    func createOutlineCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, text) in
            var content = cell.defaultContentConfiguration()
            content.text = text
//            content.secondaryText = emoji.title
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
//    /// - Tag: ConfigureListCell
//    func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
//        return UICollectionView.CellRegistration<UICollectionViewListCell, Item> { [weak self] (cell, indexPath, item) in
//            guard let self = self, let emoji = item.emoji else { return }
//            var content = UIListContentConfiguration.valueCell()
//            content.text = emoji.text
//            content.secondaryText = String(describing: emoji.category)
//            cell.contentConfiguration = content
//            cell.accessories = self.accessoriesForListCellItem(item)
//        }
//    }
    
    /// - Tag: DequeueCells
    func configureDataSource() {
        // create registrations up front, then choose the appropriate one to use in the cell provider
//        let gridCellRegistration = createGridCellRegistration()
//        let listCellRegistration = createListCellRegistration()
        let outlineHeaderCellRegistration = createOutlineHeaderCellRegistration()
        let outlineCellRegistration = createOutlineCellRegistration()
        
        // data source
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
//            case .recents:
//                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item.emoji)
//            case .list:
//                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            case .test:
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
        
        // recents (orthogonal scroller)
        
//        let recentItems = Emoji.Category.recents.emojis.map { Item(emoji: $0) }
//        var recentsSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
//        recentsSnapshot.append(recentItems)
//        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)

        // list of all + outlines
        
//        var allSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        
        for category in Emoji.Category.allCases {
            // append to the "all items" snapshot
//            let allSnapshotItems = category.emojis.map { Item(emoji: $0) }
//            allSnapshot.append(allSnapshotItems)
            
            // setup our parent/child relations
            let rootItem = Item(title: String(describing: category), hasChildren: true)
            outlineSnapshot.append([rootItem])
            let outlineItems = testData[category.rawValue].map { Item(title:$0) }
            outlineSnapshot.append(outlineItems, to: rootItem)
        }
        
//        dataSource.apply(recentsSnapshot, to: .recents, animatingDifferences: false)
//        dataSource.apply(allSnapshot, to: .list, animatingDifferences: false)
        dataSource.apply(outlineSnapshot, to: .test, animatingDifferences: false)
        
        // prepopulate starred emojis
        
//        for _ in 0..<5 {
//            if let item = allSnapshot.items.randomElement() {
//                self.starredEmojis.insert(item)
//            }
//        }
    }
}


//extension WorkSpaceHomeInitViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.testData.count
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return section == 2 ? 0 : 60
//       }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 2{
//            return nil
//        }
//        
//        let sectionButton = UIButton()
//        sectionButton.setTitle(testsection(rawValue: section)?.title,for: .normal)
//        sectionButton.backgroundColor = .black
//        sectionButton.tag = section
//        sectionButton.addTarget(self, action: #selector(self.hideSection(sender:)), for: .touchUpInside)
//
//        return sectionButton
//    }
//    
//    @objc
//    private func hideSection(sender: UIButton) {
//        // section의 tag 정보를 가져와서 어느 섹션인지 구분한다.
//        let section = sender.tag
//        
//        // 특정 섹션에 속한 행들의 IndexPath들을 리턴하는 메서드
//        func indexPathsForSection() -> [IndexPath] {
//            var indexPaths = [IndexPath]()
//            
//            for row in 0..<self.testData[section].count {
//                indexPaths.append(IndexPath(row: row,
//                                            section: section))
//            }
//            return indexPaths
//        }
//        
//        // 가져온 section이 원래 감춰져 있었다면
//        if self.hiddenSections.contains(section) {
//            self.hiddenSections.remove(section)
//            self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
//            // 섹션을 노출시킬때 원래 감춰져 있던 행들이 다 보일 수 있게 한다.
//            self.tableView.scrollToRow(at: IndexPath(row: self.testData[section].count - 1,
//                            section: section), at: UITableView.ScrollPosition.bottom, animated: true)
//        } else {
//            // section이 원래 노출되어 있었다면 행들을 감춘다.
//            self.hiddenSections.insert(section)
//            self.tableView.deleteRows(at: indexPathsForSection(),
//                                      with: .fade)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // 섹션이 hidden이므로 행을 노출시키지 않는다.
//        if self.hiddenSections.contains(section) {
//            return 0
//        }
//        // 가진 데이터의 개수만큼 노출시킨다.
//        return testData[section].count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        
//        cell.textLabel?.text = testData[indexPath.section][indexPath.row]
//            
//        return cell
//    }
//    
//    
//}
