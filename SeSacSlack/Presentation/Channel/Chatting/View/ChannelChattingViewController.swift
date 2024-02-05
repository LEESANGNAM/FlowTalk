//
//  ChannelChatingViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/2/24.
//

import UIKit

class ChannelChattingViewController: BaseViewController {
    var chatname = ""
    let mainView = ChannelChattingView()
    
    let testChatData = [
        "저희 수료식이 언제였죠? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?",
        "컨퍼런스 사진 공유드려요!",
    """
    문래역 근처 맛집 추천 받습니다~
    창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠..
    맛잘알 계신가요?
    """,
    """
    아니 그런데 이건 좀
    이렇게 저렇게?
    ㅋㅋ
    """,
        "저희 수료식이 언제였죠? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?",
        "컨퍼런스 사진 공유드려요!",
    """
    문래역 근처 맛집 추천 받습니다~
    창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠..
    맛잘알 계신가요?
    """,
    """
    아니 그런데 이건 좀
    이렇게 저렇게?
    ㅋㅋ
    """,
        "저희 수료식이 언제였죠? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?",
        "컨퍼런스 사진 공유드려요!",
    """
    문래역 근처 맛집 추천 받습니다~
    창작촌이 있어서 생각보다 맛집 많을거 같은데 막상 어디를 가야할지 잘 모르겠..
    맛잘알 계신가요?
    """,
    """
    아니 그런데 이건 좀
    이렇게 저렇게?
    ㅋㅋ
    """
    ]
    
    let testImageArray = [
        [],
        ["a","b","c","d"],
        ["c","d","e"],
        ["a"],
        ["a","b"],
        ["a","b"],
        ["a","b","c","d"],
        ["a","b"],
        ["c","d","e"],
        ["a","b","c","d","e"],
        ["a","b"],
        ["a","b"]
    ]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        mainView.chattingInputView.plusButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        setTableView()
        setCollectionView()
        view.backgroundColor = Colors.brandWhite.color
    }
    @objc func test() {
        mainView.chattingInputView.toggleImageCollectionView()
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.chevronLeft.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationController?.navigationBar.shadowImage = nil
        navigationItem.title = chatname
        self.navigationController?.navigationBar.barTintColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
    }
    
    func setCollectionView() {
        mainView.chattingInputView.ImageCollectionView.delegate = self
        mainView.chattingInputView.ImageCollectionView.dataSource = self
    }
}

extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testChatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingTableViewCell.identifier, for: indexPath) as? ChannelChattingTableViewCell else { return UITableViewCell()}
        cell.nameLabel.text = "테스트유저 \(indexPath.row)"
        cell.chattingLabel.text = testChatData[indexPath.row]
        cell.setdata(test: testImageArray[indexPath.row])
        cell.layoutIfNeeded()
        return cell
    }
    
}

extension ChannelChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelChattingInputImageCell.identifier, for: indexPath) as? ChannelChattingInputImageCell else { return  UICollectionViewCell()}
        cell.fileImageView.backgroundColor = .systemBlue
        
        return cell
    }
    
    
}
