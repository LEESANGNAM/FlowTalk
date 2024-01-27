//
//  WorkSpaceAddViewModel.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa

class WorkSpaceEditViewModel {
    
    let disposeBag = DisposeBag()
    let workSpaceUseCase: WorkSpaceUseCase
    
    let workspaceData = BehaviorRelay<SearchWorkSpacesResponseDTO?>(value: nil)
    
    init(workSpaceUseCase: WorkSpaceUseCase) {
        self.workSpaceUseCase = workSpaceUseCase
    }
    
    private let nameText = BehaviorRelay(value: "")
    private let descriptionText = BehaviorRelay<String?>(value: nil)
    private let imageData = BehaviorRelay<Data?>(value: nil)
    
    private let errorMessage = PublishRelay<String>()
    let isSuccess = BehaviorRelay(value: false)
    let isUpdate = BehaviorRelay(value: false)
    struct Input {
        let nameTextFieldChanged: ControlProperty<String>
        let descriptionTextFieldChanged: ControlProperty<String>
        let doneButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let doneButtonValid: BehaviorRelay<Bool>
        let createSuccess: PublishRelay<Bool>
        let errorMessage: PublishRelay<String>
        let imageData: BehaviorRelay<Data?>
        let isSuccess: BehaviorRelay<Bool>
        let isUpdate: BehaviorRelay<Bool>
        let workspaceData: BehaviorRelay<SearchWorkSpacesResponseDTO?>
    }
    
    func transform(input: Input) -> Output {
        let imageValid = BehaviorRelay(value: false)
        let textValid = BehaviorRelay(value: false)
        let doneButtonValid = BehaviorRelay(value: false)
        let createSuccess = PublishRelay<Bool>()
        
        imageData.map { $0 != nil }
            .bind(to: imageValid)
            .disposed(by: disposeBag)
        
        input.nameTextFieldChanged
            .distinctUntilChanged()
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(with: self) { owner, value in
                doneButtonValid.accept(value)
                textValid.accept(value)
            }.disposed(by: disposeBag)
        
        input.nameTextFieldChanged
            .bind(with: self) { owner, text in
                owner.nameText.accept(text)
            }.disposed(by: disposeBag)
        
        input.descriptionTextFieldChanged
            .bind(with: self) { owner, text in
                owner.descriptionText.accept(text)
            }.disposed(by: disposeBag)
        
        input.doneButtonTapped
            .bind(with: self) { owner, _ in
                if !imageValid.value {
                    owner.errorMessage.accept("워크스페이스 이미지를 등록해주세요.")
                } else if !textValid.value {
                    owner.errorMessage.accept("워크 스페이스 이름은 1~30자로 설정해주세요.")
                } else {
                    guard let imageData = owner.imageData.value else {
                        owner.errorMessage.accept("워크스페이스 이미지를 등록해주세요.")
                        return
                    }
                    if let data = owner.workspaceData.value{
                        owner.EditWorkSpace(data: data, imageData: imageData)
                    } else {
                        owner.addWorkSpace(imageData: imageData)
                    }
                }
            }.disposed(by: disposeBag)
        
        
        
        return Output(
            doneButtonValid: doneButtonValid,
            createSuccess: createSuccess,
            errorMessage: errorMessage,
            imageData: imageData,
            isSuccess: isSuccess,
            isUpdate: isUpdate,
            workspaceData: workspaceData
        )
    }
    
    func setImageData(_ imageData: Data?) {
        self.imageData.accept(imageData)
    }
    
    private func addWorkSpace(imageData: Data) {
        let workspace = AddWorkSpaceRequestDTO(
            name: nameText.value,
            desctiption: descriptionText.value,
            image: imageData
        )
        let result = workSpaceUseCase.addWorkSpace(workSpace: workspace)
        result.subscribe(with: self) { owner, value in
            print("워크스페이스 생성 성공", value)
            UserDefaultsManager.workSpaceId = value.workspace_id
        } onError: { owner, error in
            if let workspaceError = error as? WorkSpaceErrorType{
                print("워크스페이스 에러,",workspaceError.message)
                owner.isSuccess.accept(false)
            }else {
                print("error:",error)
                owner.isSuccess.accept(false)
            }
        } onCompleted: { owner in
            print("워크스페이스 생성 완료")
            owner.isSuccess.accept(true)
        } onDisposed: { _ in
            print("워크스페이스 생성 디스포즈")
        }.disposed(by: disposeBag)
    }
    
    private func EditWorkSpace(data: SearchWorkSpacesResponseDTO, imageData: Data) {
        let workspace = EditWorkSpaceRequestDTO(
            id: data.workspace_id,
            name: nameText.value,
            desctiption: descriptionText.value,
            image: imageData
        )
        
        let result = workSpaceUseCase.editWorkSpace(workSpace: workspace)
        result.subscribe(with: self) { owner, value in
            print("워크스페이스 수정",value)
        } onError: { owner, error in
            if let workspaceError = error as? WorkSpaceErrorType{
                print("워크스페이스 에러,",workspaceError.message)
                owner.isUpdate.accept(false)
            }else {
                print("error:",error)
                owner.isUpdate.accept(false)
            }
        } onCompleted: { owner in
            print("워크스페이스 수정 완료")
            owner.isUpdate.accept(true)
        } onDisposed: { _ in
            print("워크스페이스 수정 디스포즈")
        }.disposed(by: disposeBag)
    }
}
