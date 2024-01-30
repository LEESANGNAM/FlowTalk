//
//  ChangeAdminRequestDTO.swift
//  SeSacSlack
//
//  Created by 이상남 on 1/31/24.
//

import Foundation


struct WorkSpaceChangeAdminRequestDTO: Encodable {
    let workspaceId: Int
    let userId: Int
}
