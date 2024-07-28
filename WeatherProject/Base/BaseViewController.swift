//
//  BaseViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Network
import Toast
import UIKit

class BaseViewController: UIViewController {

    var reconnectTask: (() -> Void)? = nil
    private let networkMonitor = NWPathMonitor()
    private let specificNetworkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorNetworkStatus()
        configureView()
    }
    func configureView() {
        
    }
}

// 네트워크 관련 코드
extension BaseViewController {
    private func monitorNetworkStatus() {
        networkMonitor.pathUpdateHandler = { path in // 상태 반환
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("connected") // 네트워크 연결
                    self.reconnectTask?()
                } else {
                    print("🐈‍⬛ 끊김")
                    self.view.makeToast("네트워크가 끊겼습니다", duration: 2.0, position: .top)
                }
            }
        }
        self.networkMonitor.start(queue: DispatchQueue.global())
    }
}
