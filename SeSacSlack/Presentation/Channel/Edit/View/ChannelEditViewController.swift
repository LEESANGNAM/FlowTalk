//
//  channelEditViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/31/24.
//

import UIKit
import RxSwift
import RxCocoa

class ChannelEditViewController: BaseViewController {
    let nameLabel = CustomFontColorLabel(text: "채널 이름", font: Font.title2.fontWithLineHeight(), textAlignment: .left)
    let infoLabel = CustomFontColorLabel(text: "채널 설명", font: Font.title2.fontWithLineHeight(), textAlignment: .left)
    
    let nameTextField = CustomPlaceHolderTextField("채널 이름을 입력하세요 (필수)")
    let infoTextField = CustomPlaceHolderTextField("채널을 설명하세요 (옵션)")
    
    let doneButton = CustomBackgroundTitleButton(title: "생성", color: Colors.brandInactive.color)
    
    override func setHierarchy() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(infoLabel)
        view.addSubview(infoTextField)
        view.addSubview(doneButton)
    }
    
    override func setConstraint() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        infoTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    
    let viewModel: ChannelEditViewModel
    let disposeBag = DisposeBag()
    init(viewModel: ChannelEditViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bind()
    }
   
    private func bind() {
        let input = ChannelEditViewModel.Input(
            nameTextFieldChanged: nameTextField.rx.text.orEmpty,
            infoTextFieldChanged: infoTextField.rx.text.orEmpty,
            doneButtonTapped: doneButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.emptyValid
            .bind(with: self) { owner, value in
                owner.doneButton.isEnabled = value
                owner.doneButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        output.errormessage
            .bind(with: self) { owner, errorText in
                owner.showToast(message: errorText)
            }.disposed(by: disposeBag)
        
        output.isSuccess
            .bind(with: self) { owner, value in
                if value {
                    print("생성 성공")
                    owner.dismiss(animated: true)
                }
            }.disposed(by: disposeBag)
        
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "채널 생성"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
