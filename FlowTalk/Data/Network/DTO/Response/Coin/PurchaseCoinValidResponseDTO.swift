//
//  PurchaseCoinResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 3/1/24.
//

import Foundation

struct PurchaseCoinValidResponseDTO: Decodable {
    let billing_id : Int //결제 내역아이디
    let merchant_uid: String // 결제 시 등록한 상점 고유번호
    let amount: Int // 금액
    let sesacCoin: Int // 아이템
    let success: Bool // 성공여부
    let createdAt: String // 시간
}
