//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/17.
//

import SwiftUI
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    // MARK: - UI
    private let videoPlayerHeight: CGFloat = 360
    private let videoPlayerView = VideoPlayerView()
    private var videoPlayerHeightConstraint: Constraint?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservable()
        playVideo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.handleOrientationChange()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(videoPlayerView)
        videoPlayerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            self.videoPlayerHeightConstraint = $0.height.equalTo(videoPlayerHeight).constraint
        }
    }
    
    private func setupObservable() {
        videoPlayerView.isFullScreenRelay
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] isFullScreen in
                guard let self, let windowSceen = self.view.window?.windowScene else { return }
                if windowSceen.interfaceOrientation == .portrait {
                    windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                        print(error.localizedDescription)
                    }
                    
                    updateVideoPlayerView(isPortrait: false)
                } else {
                    windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                        print(error.localizedDescription)
                    }
                    
                    updateVideoPlayerView(isPortrait: true)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func playVideo() {
        videoPlayerView.loadVideo(from: URL(string: "https://videos.files.wordpress.com/YLhNpIDh/like-a-boss-ft.-seth-rogen-uncensored-version-1.mp4")!)
    }
    
    private func handleOrientationChange() {
        guard let windowInterface = self.windowInterface else { return }
        updateVideoPlayerView(isPortrait: windowInterface.isPortrait)
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return view.window?.windowScene?.interfaceOrientation
    }
    
    private func updateVideoPlayerView(isPortrait: Bool) {
        if isPortrait {
            self.videoPlayerHeightConstraint?.update(offset: videoPlayerHeight)
        } else {
            self.videoPlayerHeightConstraint?.update(offset: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height))
            
        }
        videoPlayerView.changeFullScreenMode(isFullScreen: !isPortrait)
        videoPlayerView.updateVideoLayerFrame()
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
