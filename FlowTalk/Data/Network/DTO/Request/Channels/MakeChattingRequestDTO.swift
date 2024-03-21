//
//  MakeChattingRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/13/24.
//

import Foundation

struct MakeChattingRequestDTO: Encodable {
    let name: String
    let workspace_id: Int
    
    let content: String?
    let files: [Data]
}
