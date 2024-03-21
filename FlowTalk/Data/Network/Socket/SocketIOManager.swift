//
//  SocketIOManager.swift
//  SeSacSlack
//
//  Created by 이상남 on 2/22/24.
//

import Foundation
import SocketIO
import RxSwift

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    private init() { }
    
    let chatData = PublishSubject<SearchChattingResponseDTO>()
    
    var isConnect = false
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    func config(type: SocketRouter) {
        manager = SocketManager(socketURL: type.url, config: [.compress])
        socket = manager.socket(forNamespace: type.path)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED")
            self.isConnect = true
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED")
            self.isConnect = false
        }
    }
    
    func receive<T: Decodable>(type: T.Type, api: SocketRouter) -> Observable<T> {
        return Observable<T>.create { observer in
            
            self.socket.on(api.event) { dataArray, ack in
                print("소켓통신테스트:",dataArray)
                guard let data = dataArray.first,
                      let decodeData: T = try? self.decodeData(data: data) else { return }
                observer.onNext(decodeData)
            }
            
            return Disposables.create()
        }
    }
    
    func decodeData<T: Decodable>(data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let decodeData = try JSONDecoder().decode(T.self, from: jsonData)
        return decodeData
    }
    
    func connect() {
        if isConnect {
            disconnect()
        }
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    
}
