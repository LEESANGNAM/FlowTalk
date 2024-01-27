//
//  WorkSpaceAddViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class WorkSpaceAddViewController: BaseViewController {
    let posterImageView = {
        let view = UIImageView()
        view.backgroundColor = Colors.brandGreen.color
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
       return view
    }()
    let posterButton = {
        let view = UIButton()
        view.setImage(Icon.workspace.image, for: .normal)
        view.setImage(Icon.workspace.image, for: .highlighted)
        view.addTarget(self, action: #selector(posterButtonTapped), for: .touchUpInside)
        view.tintColor = Colors.brandWhite.color
        view.layer.cornerRadius = 8
        return view
    }()
    
    let cameraImageView = {
        let view = UIImageView()
        view.image = Icon.camera.image
        view.backgroundColor = Colors.brandGreen.color
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderColor = Colors.brandWhite.color.cgColor
        return view
    }()
    let workSpaceNameLabel = CustomFontColorLabel(text: "워크스페이스 이름", font: Font.title2.fontWithLineHeight())
    let workSpaceInfoLabel = CustomFontColorLabel(text: "워크스페이스 설명", font: Font.title2.fontWithLineHeight())
    
    let workSpaceNameTextField = CustomPlaceHolderTextField("워크스페이스 이름을 입력하세요 (필수) ")
    let workSpaceInfoTextField = CustomPlaceHolderTextField("워크스페이스를 설명하세요 (옵션) ")
    
    let doneButton = CustomBackgroundTitleButton(title: "완료", color: Colors.brandGray.color)
    
    override func setHierarchy() {
        view.addSubview(posterImageView)
        view.addSubview(posterButton)
        view.addSubview(cameraImageView)
        view.addSubview(workSpaceNameLabel)
        view.addSubview(workSpaceNameTextField)
        view.addSubview(workSpaceInfoLabel)
        view.addSubview(workSpaceInfoTextField)
        view.addSubview(doneButton)
    }
    
    override func setConstraint() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        posterButton.snp.makeConstraints { make in
            make.centerX.equalTo(posterImageView)
            make.bottom.equalTo(posterImageView.snp.bottom)
            make.width.equalTo(48)
            make.height.equalTo(60)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.equalTo(posterImageView.snp.bottom).offset(5)
            make.trailing.equalTo(posterImageView.snp.trailing).offset(5)
        }
        workSpaceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(posterButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        workSpaceNameTextField.snp.makeConstraints { make in
            make.top.equalTo(workSpaceNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        workSpaceInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(workSpaceNameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        workSpaceInfoTextField.snp.makeConstraints { make in
            make.top.equalTo(workSpaceInfoLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    let viewmodel: WorkSpaceAddViewModel
    let disposeBag = DisposeBag()
    var picker: PHPickerViewController!
    init(viewmodel: WorkSpaceAddViewModel) {
        self.viewmodel = viewmodel
        super.init()
    }
    
}

extension WorkSpaceAddViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setPHPicker()
        bind()
    }
    
    private func bind() {
        let input = WorkSpaceAddViewModel.Input(
            nameTextFieldChanged: workSpaceNameTextField.rx.text.orEmpty,
            descriptionTextFieldChanged: workSpaceInfoTextField.rx.text.orEmpty,
            doneButtonTapped: doneButton.rx.tap)
        let output = viewmodel.transform(input: input)
        
        output.doneButtonValid
            .bind(with: self) { owner, value in
                owner.doneButton.isEnabled = value
                owner.doneButton.backgroundColor = value ? Colors.brandGreen.color : Colors.brandGray.color
            }.disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, errorText in
                owner.showToast(message: errorText)
            }.disposed(by: disposeBag)
        
        output.workspaceData
            .bind(with: self) { owner, workspace in
                guard let workspace else { return }
                owner.workSpaceNameTextField.text = workspace.name
                owner.workSpaceInfoTextField.text = workspace.description
                owner.doneButton.setTitle("저장", for: .normal)
                owner.posterButton.setImage(nil, for: .normal)
                owner.posterButton.setImage(nil, for: .highlighted)
            }.disposed(by: disposeBag)
        
        output.imageData
            .bind(with: self) { owner, data in
                if let data {
                    owner.posterImageView.image = UIImage(data: data)
                }
            }.disposed(by: disposeBag)
        
        output.isSuccess
            .bind(with: self) { owner, value in
                if value {
                    ViewManager.shared.changeRootView(
                        TabbarController()
                    )
                }
            }.disposed(by: disposeBag)
        
    }
    
    private func setNavigationBar() {
        let backButtonItem = UIBarButtonItem(image: Icon.close.image , style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.brandBlack.color
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "워크스페이스 생성"
        self.navigationController?.navigationBar.backgroundColor = Colors.backgroundSecondar.color
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func posterButtonTapped() {
        present(picker,animated: true)
    }
    
    private func setPHPicker(){
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.filter = .images
        picker = PHPickerViewController(configuration: phPickerConfiguration)
        picker.delegate = self
    }
}


extension WorkSpaceAddViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProvider = results.first?.itemProvider // 2
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] (image, error) in // 4
                DispatchQueue.main.async { [weak self] in
                    if let selectImage = image as? UIImage,
                        let size = self?.posterImageView.frame.size,
                       let imageData = selectImage.resized(to: size)?.jpegData(compressionQuality: 1.0){
                        self?.viewmodel.setImageData(imageData)
                        self?.posterButton.setImage(nil, for: .normal)
                        self?.posterButton.setImage(nil, for: .highlighted)
                    }
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
    
}
