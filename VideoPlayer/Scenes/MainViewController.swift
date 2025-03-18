//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/17.
//

import SwiftUI
import UIKit
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - UI
    private let videoPlayerView = VideoPlayerView()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        videoPlayerView.loadVideo(from: URL(string: "https://v.redd.it/kkxwy09lsi1e1/DASH_1080.mp4")!)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(360)
            $0.left.right.equalToSuperview()
        }
    }
}

// MARK: - UIViewControllerRepresentable
struct MainViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
        return MainViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        
    }
}
