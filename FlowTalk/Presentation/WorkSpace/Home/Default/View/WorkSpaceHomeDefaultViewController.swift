//
//  WorkSpaceHomeInitViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/15/24.
//

import UIKit
import RxSwift
import RxCocoa


class WorkSpaceHomeDefaultViewController: BaseViewController {
    
    let transition = SlideInTransition()
    
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
    
    
    let workSpaceNaviBar = WorkSpaceProfileView()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, homeDefaultListItem>!
    
    let disposeBag = DisposeBag()
    let viewModel: WorkSpaceHomeDefaultViewModel
    
    init(viewModel: WorkSpaceHomeDefaultViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        setUpBackgroundColors()
        bind()
        setPanGesture()
        setProfileTapGesture()
    }
    
    private func setProfileTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        workSpaceNaviBar.profileImageView.isUserInteractionEnabled = true
        workSpaceNaviBar.profileImageView.addGestureRecognizer(tapGesture)
    }
    @objc private func profileTapped() {
        let vc = UINavigationController(rootViewController: CoinViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    private func setPanGesture() {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func handleScreenEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            let vc = WorkSpaceListViewController(
                viewModel: WorkSpaceListViewModel(
                    workspaceUseCase: DefaultWorkSpaceUseCase(
                        workSpaceRepository: DefaultWorkSpaceRepository()
                    )
                )
            )
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    func bind() {
        
        let input = WorkSpaceHomeDefaultViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map { _ in})
        let output = viewModel.transform(input: input)
        
        output.homeListData
            .bind(with: self) { owner, array in
                if array.isEmpty { return }
                owner.applyInitialSnapshots()
            }.disposed(by: disposeBag)
        
        output.workspace
            .bind(with: self) { owner, workspace in
                owner.workSpaceNaviBar.setWorkspaceIcon(workspace: workspace)
                owner.workSpaceNaviBar.setProfileIcon()
            }.disposed(by: disposeBag)
        
        
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

extension WorkSpaceHomeDefaultViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
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
    
    func createOutlineCellRegistration() -> UICollectionView.CellRegistration<IconImageCollectionViewCell, homeDefaultListItem> {
        return UICollectionView.CellRegistration<IconImageCollectionViewCell, homeDefaultListItem> { (cell, indexPath, homeDefaultListItem) in
            if let section = Section(rawValue: indexPath.section){
                switch section {
                case .channel:
                    cell.setupchnnal(data: homeDefaultListItem)
                    break
                case .directmessage:
                    cell.setupDM(image: nil, data: homeDefaultListItem)
                    break
                case .addMember:
                    break
                }
                let itemCount = self.collectionView.numberOfItems(inSection: indexPath.section)
                if indexPath.item == itemCount - 1 {
                    cell.setupLast(title: homeDefaultListItem.title)
                    cell.setupChatCount(0)
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
        dataSource = UICollectionViewDiffableDataSource<Section, homeDefaultListItem>(collectionView: collectionView) {
            (collectionView, indexPath, homeDefaultListItem) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .channel,.addMember,.directmessage:
                if homeDefaultListItem.hasChildren {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineHeaderCellRegistration, for: indexPath, item: homeDefaultListItem.title)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(using: outlineCellRegistration, for: indexPath, item: homeDefaultListItem)
                }
            }
        }
    }
    
    /// - Tag: SectionSnapshot
    func applyInitialSnapshots() {
        // set the order for our sections
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, homeDefaultListItem>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        for category in sections {
            //  outlines
            var outlineSnapshot = NSDiffableDataSourceSectionSnapshot<homeDefaultListItem>()
            
            var rootItem: homeDefaultListItem
            if case Section.addMember = category {
                rootItem = homeDefaultListItem(title: String(describing: category.title), hasChildren: false)
            } else {
                rootItem = homeDefaultListItem(title: String(describing: category.title), hasChildren: true)
            }
            outlineSnapshot.append([rootItem])
            
            var outlineItems: [homeDefaultListItem]
            switch category {
            case .channel:
                outlineItems = viewModel.getchannelArray()
                outlineItems.append(homeDefaultListItem(title: "채널추가"))
            case .directmessage:
                outlineItems = viewModel.getdmArray()
                outlineItems.append(homeDefaultListItem(title: "새 메시지 시작"))
            case .addMember:
                outlineItems = Array(arrayLiteral: homeDefaultListItem(title: "팀원추가"))
            }
            outlineSnapshot.append(outlineItems, to: rootItem)
            dataSource.apply(outlineSnapshot, to: category, animatingDifferences: false)
        }
        
    }
}

extension WorkSpaceHomeDefaultViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresenting = true
            return transition
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transition.isPresenting = false
            return transition
        }
}

extension WorkSpaceHomeDefaultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        let lastItemIndex = collectionView.numberOfItems(inSection: indexPath.section) - 1
        if indexPath.item == lastItemIndex {
            switch section {
            case .channel:
                print("채널추가")
                showActionSheet {
                    print("채널 생성뷰 짜잔")
                    self.showAddChannelView()
                } searchAction: {
                    print("채널 탐색뷰 짜잔")
                }

            case .directmessage:
                print("dm추가")
            case .addMember:
                print("팀원추가")
                showAddmemberView()
            }
        } else {
            switch section {
            case .channel:
                print("채널클릭")
                let channel = viewModel.getChannel(index: indexPath.row)
                showChattingView(name: channel.name,id: channel.channel_id)
            case .directmessage:
                print("dm 클릭")
            case .addMember:
                print("팀원클릭")
            }
        }
    }
    private func showActionSheet(addAction: @escaping () -> Void, searchAction: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var actionArray: [UIAlertAction] = []
        let addAction = UIAlertAction(title: "채널 생성", style: .default) { _ in
            addAction()
        }
        let searchAction = UIAlertAction(title: "채널 탐색", style: .default) { _ in
            searchAction()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionArray.append(addAction)
        actionArray.append(searchAction)
        actionArray.append(cancelAction)
        
        actionArray.forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
    func showChattingView(name: String,id: Int) {
        let vm = ChannelChatiingViewModel(
            chattingUseCase: DefaultChannelChattingUseCase(
                channelChattingRepository: DefaultChannelChattingRepository(chattingStorage: ChannelChattingStorage()!)
            ),
            channelId: id
        )
        vm.chatname = name
        let vc = ChannelChattingViewController(viewModel: vm)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true)
    }
    func showAddChannelView() {
        let vc = ChannelEditViewController(
            viewModel: ChannelEditViewModel(
                channelUseCase: DefaultChannelUseCase(
                    channelRepository: DefaultChannelRepository()
                )
            )
        )
        
        vc.completeObservable()
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.fetch()
                owner.showToast(message: "채널이 생성되었습니다.")
            }.disposed(by: vc.disposeBag)
        
        showPresentView(vc: vc)
    }
    func showAddmemberView() {
        let vc = AddMemberViewController(
            viewModel: AddMemberViewModel(
                workSpaceUseCase: DefaultWorkSpaceUseCase(
                    workSpaceRepository: DefaultWorkSpaceRepository()
                )
            )
        )
        
        vc.completeObservable()
            .bind(with: self) { owner, _ in
                WorkSpaceManager.shared.fetch()
                owner.showToast(message: "멤버를 성공적으로 초대했습니다.")
            }.disposed(by: vc.disposeBag)
        
       showPresentView(vc: vc)
    }
}


