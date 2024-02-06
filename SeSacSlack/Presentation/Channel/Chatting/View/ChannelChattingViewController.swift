//
//  ChannelChatingViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI


class ChannelChattingViewController: BaseViewController {
    var chatname = ""
    let mainView = ChannelChattingView()
    let disposeBag = DisposeBag()
    var picker: PHPickerViewController!
    private let textViewPlaceHolder = "메세지를 입력하세요"
    
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
        mainView.chattingInputView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        setTableView()
        setCollectionView()
        setPHPicker()
        setTextViewPlaceHolder()
        view.backgroundColor = Colors.brandWhite.color
        bind()
    }
    private func bind(){
        textViewBind()
    }
    private func textViewBind() {
        
        mainView.chattingInputView.chattingTextView.rx
            .didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.mainView.chattingInputView.chattingTextView.text == owner.textViewPlaceHolder{
                    owner.mainView.chattingInputView.chattingTextView.text = nil
                    owner.mainView.chattingInputView.chattingTextView.textColor = Colors.textPrimary.color
                }
            }.disposed(by: disposeBag)
        
        mainView.chattingInputView.chattingTextView.rx
            .didEndEditing
            .bind(with: self) { owner, _ in
                if owner.mainView.chattingInputView.chattingTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.setTextViewPlaceHolder()
                }
            }.disposed(by: disposeBag)
        
        
        mainView.chattingInputView.chattingTextView.rx
            .didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.mainView.chattingInputView.chattingTextView.frame.width, height: .infinity)
                let estimatedSize = owner.mainView.chattingInputView.chattingTextView.sizeThatFits(size)
                print("텍스트뷰사이즈======",estimatedSize)
                // 1줄 31.6
                //2줄 47.3
                //3줄 62.6
                let isMaxHeight = estimatedSize.height >= 60
                
                guard isMaxHeight != owner.mainView.chattingInputView.chattingTextView.isScrollEnabled else { return }
                owner.mainView.chattingInputView.chattingTextView.isScrollEnabled = isMaxHeight
                owner.mainView.chattingInputView.chattingTextView.reloadInputViews()
                owner.mainView.chattingInputView.chattingTextView.setNeedsUpdateConstraints()
            }.disposed(by: disposeBag)
    }
    private func setTextViewPlaceHolder() {
        mainView.chattingInputView.chattingTextView.text = textViewPlaceHolder
        mainView.chattingInputView.chattingTextView.textColor = Colors.textSecondary.color
    }
    
    @objc func plusButtonTapped() {
//        mainView.chattingInputView.toggleImageCollectionView()
        present(picker, animated: true)
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
    var imagedataArray:[Data] = [] {
        didSet {
            if imagedataArray.count != 0{
                DispatchQueue.main.async{
                    self.mainView.chattingInputView.toggleImageCollectionView()
                }
            }
            DispatchQueue.main.async{
                self.mainView.chattingInputView.ImageCollectionView.reloadData()
            }
        }
    }
}

extension ChannelChattingViewController: PHPickerViewControllerDelegate{
    
    private func setPHPicker(){
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.filter = .images
        phPickerConfiguration.selectionLimit = 5
        picker = PHPickerViewController(configuration: phPickerConfiguration)
        picker.delegate = self
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty { return }
        
        //        let itemProvider = results.first?.itemProvider // 2
        for (index, item) in results.enumerated() {
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in // 4
                    DispatchQueue.global().async { [weak self] in
                        guard let image = image as? UIImage else { return }
                        guard let imageData = image.jpegData(compressionQuality: 0.001) else  { return }
                        
                        //                            self?.viewmodel.setImageData(imageData)
                        self?.imagedataArray.append(imageData)
                    }
                }
            }
            
        }
        dismiss(animated: true)
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
        return imagedataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelChattingInputImageCell.identifier, for: indexPath) as? ChannelChattingInputImageCell else { return  UICollectionViewCell()}
        cell.fileImageView.backgroundColor = .systemBlue
        cell.fileImageView.image = UIImage(data: imagedataArray[indexPath.item])
        return cell
    }
    
    
}
