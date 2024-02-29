//
//  PurchaseCoinRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 3/1/24.
//

import Foundation


struct PurchaseCoinValidRequestDTO: Encodable {
    let imp_uid: String
    let merchant_uid: String
}
