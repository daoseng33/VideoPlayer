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
        videoPlayerView.loadVideo(from: URL(string: "https://videos.files.wordpress.com/YLhNpIDh/like-a-boss-ft.-seth-rogen-uncensored-version-1.mp4")!)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(360)
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
