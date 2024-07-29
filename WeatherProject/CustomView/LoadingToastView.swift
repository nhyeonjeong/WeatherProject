//
//  LoadingToastView.swift
//  WeatherProject
//
//  Created by 남현정 on 2024/07/29.
//

import Foundation
import Lottie
import SnapKit

final class LoadingToastView: BaseView {
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "loadingLottie")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    override func configureHierarchy() {
        addSubview(animationView)
    }
    override func configureConstratinst() {
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        self.backgroundColor = .white.withAlphaComponent(0.8)
        self.layer.cornerRadius = self.bounds.width / 2
        animationView.play()
    }
}
