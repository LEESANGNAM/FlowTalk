//
//  EditWorkSpaceRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/27/24.
//

import Foundation


struct EditWorkSpaceRequestDTO: Encodable {
    let id: Int
    let name: String
    let desctiption: String?
    let image: Data
}
