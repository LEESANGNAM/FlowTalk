//
//  File.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/29/24.
//

import UIKit
import RxSwift
import RxCocoa


class AddMemberViewController: BaseViewController {
 
    let emailLabel = CustomFontColorLabel(text: "이메일", font: Font.title2.fontWithLineHeight(),textAlignment: .left)
    let emailTextField = CustomPlaceHolderTextField("초대하려는 팀원의 이메일을 입력하세요.")
    let doneButton = CustomBackgroundTitleButton(title: "초대보내기", color: Colors.brandInactive.color)
    
    override func setHierarchy() {
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(doneButton)
    }
    override func setConstraint() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    
    let disposeBag = DisposeBag()
    private let completeSubject = PublishSubject<Void>()
    let viewModel: AddMemberViewModel
    init(viewModel: AddMemberViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bind()
    }
    
    func bind() {
        let input = AddMemberViewModel.Input(
            emailTextFieldChange: emailTextField.rx.text.orEmpty,
            doneButtonTapped: doneButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.errorMessage
            .bind(with: self) { owner, errorText in
                owner.showToast(message: errorText)
            }.disposed(by: disposeBag)
        
        output.isEmptyCheck
            .bind(with: self) { owner, value in
                owner.doneButton.isEnabled = value
                owner.doneButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandInactive.color
            }.disposed(by: disposeBag)
        
        output.isSuccess
            .bind(with: self) { owner, value in
                if value {
                    owner.addMemeberSuccess()
                }
            }.disposed(by: disposeBag)
        
    }
    
    //완료 동작
    private func addMemeberSuccess() {
        completeSubject.onNext(())
        dismiss(animated: true)
    }

    // 외부 구독용
    func completeObservable() -> Observable<Void> {
        return completeSubject.asObservable()
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "팀원 초대"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
