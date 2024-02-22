//
//  ChannelChattingStorage.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/21/24.
//

import Foundation
import RealmSwift
import RxSwift
//protocol ChannelChattingStorageProtocol: AnyObject {
//    func addChannelChatting()
//    func readChannelChatting()
//}

class ChannelChattingStorage: BaseStorage { //, ChannelChattingStorageProtocol {
    // 메세지보내기 성공모델 + 워크스페이스 정보
    func addChannelChatting(workspaceId: Int ,chattingData: SaveChannelChattingDTO) {
        
        // 채팅 중복인지 검사부터
        if let _ = realm.object(ofType: ChannelChattingTable.self, forPrimaryKey: chattingData.chat_id){
            print("채팅아이디 있으니깐 나가")
            return
        }
        
        do {
            try realm.write {
                // 채널 없으면 먼저 추가하고? 있으면? 찾아서 넣어야함
                // 보낸 유저도 마찬가지
                // 채널 유저정보를 같이추가? -> 여기서 해당 채널 유저 찾기?
                
                // 채널검사
                if let savedChannel = realm.object(ofType: ChannelInfoTable.self, forPrimaryKey: chattingData.channel_id) {
                    // 채널있음
                    print("채널있음")
                } else {
                    let newChannel = ChannelInfoTable(chatting: chattingData, workspace_id: workspaceId)
                    realm.add(newChannel)
                }
                
                // 유저검사
                if let savedUser = realm.object(ofType: ChannelUserInfoTable.self, forPrimaryKey: chattingData.user.user_id) {
                    // 유저있음
                    print("유저있음")
                } else {
                    let newUser = ChannelUserInfoTable(user: chattingData.user)
                    realm.add(newUser)
                }
                
                // 유저 채널 추가했으니까 이제 채팅 추가
                guard let savedChannel = realm.object(ofType: ChannelInfoTable.self, forPrimaryKey: chattingData.channel_id) else { return }
                guard let savedUser = realm.object(ofType: ChannelUserInfoTable.self, forPrimaryKey: chattingData.user.user_id) else { return }
                // 위에서 추가해서 값 있음
                let newChat = ChannelChattingTable(channelTable: savedChannel, user: savedUser, chatting: chattingData)
                realm.add(newChat)
            }
        } catch {
            
        }
        
    }
    // 여기서 먼저 디비 모든정보 가져오기
    func readChannelChatting() {
        
    }
}
