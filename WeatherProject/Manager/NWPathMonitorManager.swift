//
//  File.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/29.
//

import Foundation
import Network

final class NWPathMonitorManager {
    static let shared = NWPathMonitorManager()
    
    private var isConnected = false
    private let networkMonitor = NWPathMonitor()
    private let specificNetworkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    
    private init() { }
    
    func monitorNetworkStatus(reconnectTask: @escaping (() -> Void), notConnectTask: @escaping (() -> Void)) {
        networkMonitor.pathUpdateHandler = { path in // 상태 반환
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("connected") // 네트워크 연결
                    if self.isConnected == false {
                        self.isConnected = true
                        reconnectTask()
                    }
                } else {
                    print("🐈‍⬛ 끊김")
                    if self.isConnected == true {
                        self.isConnected = false
                        notConnectTask()
                    }
                }
            }
        }
        self.networkMonitor.start(queue: DispatchQueue.global())
    }
    
}
