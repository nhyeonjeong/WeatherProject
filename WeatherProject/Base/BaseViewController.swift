//
//  BaseViewController.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/27.
//

import Toast
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNetworkTask(reconnectTask: nil)
        configureView()
    }
    func setNetworkTask(reconnectTask: (() -> Void)?) {
        NWPathMonitorManager.shared.monitorNetworkStatus(reconnectTask: {
            reconnectTask?()
        }, notConnectTask: {
            self.view.makeToast("네트워크 연결이 끊겼습니다", duration: 2.0, position: .top)
        })
    }
    func configureView() {
        
    }
}
