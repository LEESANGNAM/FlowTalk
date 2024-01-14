//
//  AddWorkSpaceRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/14/24.
//

import Foundation

struct AddWorkSpaceRequestDTO: Encodable {
    let name: String
    let desctiption: String?
    let image: Data
    
}
