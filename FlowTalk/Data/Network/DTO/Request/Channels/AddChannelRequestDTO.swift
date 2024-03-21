//
//  AddChannelRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/1/24.
//

import Foundation


struct AddChannelRequestDTO: Encodable {
    let workspace_id: Int
    let name: String
    let description: String?
}
