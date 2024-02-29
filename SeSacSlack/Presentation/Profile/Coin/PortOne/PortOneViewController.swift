//
//  PortOneViewController.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/29/24.
//

import UIKit
import WebKit
import iamport_ios

import RxSwift
import RxCocoa

class PortOneViewController: BaseViewController {
    let disposeBag = DisposeBag()
    let item: CoinStoreListResponseDTO
    let webView = WKWebView()
    var payment: IamportPayment!
    
    init(item: CoinStoreListResponseDTO) {
        self.item = item
        super.init()
    }
    
    override func setHierarchy() {
        view.addSubview(webView)
    }
    
    override func setConstraint() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setpayment()
        purchase()
        
    }
    
    
    private func setpayment() {
        payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))",
            amount: item.amount).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = item.item
                $0.buyer_name = "이상남"
                $0.app_scheme = "sesac"
            }
    }
    
    func purchase() {
        Iamport.shared.paymentWebView(webViewMode: webView,
                                      userCode: APIKey.userCode,
                                      payment: payment) { response in
            if let response {
                print("여기서 네트워크로 결제 정보 보냄")
                if self.completPurchase(data: response) {
                    if let imp_uid = response.imp_uid,
                       let merchant_uid = response.merchant_uid {
                        self.validRequest(imp_uid: imp_uid, merchant_uid: merchant_uid)
                    } else {
                        print("imp_uid/merchant_uid 해제 실패")
                    }
                } else {
                    print("결제 리스폰스에서 오류보냄")
                }
            } else {
                print("여기 결제 리스폰스 오류~~")
            }
        }
    }
    func completPurchase(data: IamportResponse) -> Bool {
        if let success = data.success,
           success {
            print("결제 리스폰스 성공")
            return true
        } else {
            if let message = data.error_msg,
               let code = data.error_code {
                print("결제 리스폰스 실패 오류: \(code) / \(message)")
                return false
            } else {
                print("모르는 결제 리스폰스 오류~")
                return false
            }
        }
    }
    
    func validRequest(imp_uid: String, merchant_uid: String) {
        let model = PurchaseCoinValidRequestDTO(imp_uid: imp_uid, merchant_uid: merchant_uid)
        NetWorkManager.shared.request(type: PurchaseCoinValidResponseDTO.self, api: .purchaseCoinValid(model))
            .subscribe(with: self) { owner, value in
                print("결제 완료 리스폰스 : ",value)
            } onError: { owner, error in
                print("결제완료 에러있어요")
            }.disposed(by: disposeBag)
    }
    
    
    
}
