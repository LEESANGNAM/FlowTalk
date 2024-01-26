//
//  CustomAlertViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/26/24.
//

import UIKit

enum AlertType {
    case onlyOk    // 확인 버튼
    case CancelOk     // 확인 + 취소 버튼
}

class CustomAlertViewController: BaseViewController {
    private var type: AlertType
    private var titleText: String
    private var messageText: String
    private var okTitle: String
    private var cancelTitle: String
    
    private var okAction: (() -> Void)?
    private var cancelAction: (() -> Void)?
    
    let alertView = {
        let view = UIView()
        view.backgroundColor = Colors.brandWhite.color
        view.layer.cornerRadius = 16
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    lazy var titleLabel = CustomFontColorLabel(
        text: titleText,
        font: Font.title2.fontWithLineHeight(),
        textColor: Colors.textPrimary.color,
        textAlignment: .center
    )
    lazy var messageLabel = CustomFontColorLabel(
        text: messageText,
        font: Font.body.fontWithLineHeight(),
        textColor: Colors.textSecondary.color,
        textAlignment: .center
    )
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var okButton = CustomBackgroundTitleButton(title: okTitle, color: Colors.brandGreen.color)
    lazy var cancelButton: CustomBackgroundTitleButton? = type == .onlyOk ? nil : CustomBackgroundTitleButton(title: cancelTitle, color: Colors.brandInactive.color)
    
    
    
    init(type: AlertType, titleText: String , messageText: String, okTitle: String, cancelTitle: String = "", okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        self.type = type
        self.titleText = titleText
        self.messageText = messageText
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
        super.init()
        
        // 확인 버튼 액션
        okButton.addTarget(self, action: #selector(handleOkButton), for: .touchUpInside)
        
        // 취소 버튼이 nil이 아니고, 취소 버튼이 있는 경우에만 취소 버튼 액션 추가
        if let cancelButton = cancelButton {
            cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        }
        
        // 외부에서 전달된 클로저 설정
        self.okAction = okAction
        self.cancelAction = cancelAction
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = Colors.alpha.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.alertView.transform = .identity
            self?.alertView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.alertView.transform = .identity
            self?.alertView.isHidden = true
        }
    }
    
    override func setHierarchy() {
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(buttonStackView)
        
        // 취소 버튼이 nil이 아닐 때만 추가
        if let cancelButton = cancelButton {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        buttonStackView.addArrangedSubview(okButton)
        
        
    }
    
    override func setConstraint() {
        alertView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
    }
    
    @objc private func handleOkButton() {
        okAction?()
    }
    
    // @objc 키워드를 사용하여 Objective-C에서 호출 가능하도록 설정
    @objc private func handleCancelButton() {
        cancelAction?()
    }
    
}
