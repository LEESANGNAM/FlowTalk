//
//  ExitWorkSpaceResponseDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/26/24.
//

import Foundation


struct ExitWorkSpaceResponseDTO: Decodable {
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
}
