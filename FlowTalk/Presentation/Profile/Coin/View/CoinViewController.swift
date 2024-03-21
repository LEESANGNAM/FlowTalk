//
//  CoinViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class CoinViewController: BaseViewController {
    
    lazy var collecionView =  {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: CoinCollectionViewCell.identifier)
        view.backgroundColor = Colors.brandGreen.color
        return view
    }()
    
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = false
        config.backgroundColor = Colors.backgroundPrimary.color
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    override func setHierarchy() {
        view.addSubview(collecionView)
    }
    override func setConstraint() {
        collecionView.dataSource = self
        collecionView.delegate = self
        collecionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    let viewModel = CoinViewModel()
    let disposeBag = DisposeBag()
    var coin = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bind()
    }
    
    private func bind() {
        let input = CoinViewModel.Input(viewWillAppear: self.rx.viewWillAppear.map{ _ in })
        let output = viewModel.transform(input: input)
        
        output.coinShopList
            .bind(with: self) { owner, _ in
                owner.collecionView.reloadData()
            }.disposed(by: disposeBag)
        
        MyInfoManager.shared.coin
            .bind(with: self) { owner, value in
                owner.coin = value
                owner.collecionView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.chevronLeft.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "코인샵"
        self.navigationController?.navigationBar.barTintColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension CoinViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.getcount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinCollectionViewCell.identifier, for: indexPath) as? CoinCollectionViewCell else { return UICollectionViewCell() }
        cell.showCoinCount(section: indexPath.section)
        if indexPath.section == 0 {
            cell.titleLabel.text = cell.icon + "현재 보유한 코인"
            cell.coinCountLabel.text = "\(coin)개"
        } else {
            cell.priceButton.tag = indexPath.row
            cell.priceButton.addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
            let data = viewModel.getitem(index: indexPath.row)
            cell.setData(data: data)
        }
        return cell
    }
    
    @objc func priceButtonTapped(_ sender: UIButton) {
        let data = viewModel.getitem(index: sender.tag)
        let vc = PortOneViewController(item: data)
        
        vc.completeObservable()
            .bind(with: self) { owner, value in
                MyInfoManager.shared.fetch()
                owner.showToast(message: "\(value.sesacCoin) Coin 이 결제 되었습니다.")
            }.disposed(by: vc.disposeBag)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
