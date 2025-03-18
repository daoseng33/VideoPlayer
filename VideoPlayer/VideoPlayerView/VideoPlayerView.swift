//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/17.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class VideoPlayerView: UIView {
    // MARK: - Properties
    private var playerLayer: AVPlayerLayer?
    private var player = AVPlayer()
    private var playerBindingsDisposeBag = DisposeBag()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    // Timer
    private var timerDisposable: Disposable?
    private let countdownSeconds = 3
    
    private let timeStatusRelay = BehaviorRelay<AVPlayer.TimeControlStatus>(value: .waitingToPlayAtSpecifiedRate)
    var timeStatus: AVPlayer.TimeControlStatus {
        timeStatusRelay.value
    }
    
    private let handleErrorRelay = PublishRelay<Void>()
    var handleErrorObservable: Observable<Void> {
        handleErrorRelay.asObservable()
    }
    
    // MARK: - UI
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray
        return indicator
    }()
    
    private let videoControlView: VideoControlView = {
        let view = VideoControlView()
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopCountdown()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer!)
        
        addGestureRecognizer(tapGestureRecognizer)
        
        addSubview(videoControlView)
        videoControlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        playerBindingsDisposeBag = DisposeBag()
        
        Observable.combineLatest(
                player.rx.observe(AVPlayer.TimeControlStatus.self, #keyPath(AVPlayer.timeControlStatus)).compactMap { $0 },
                player.rx.observe(AVPlayerItem.Status.self, #keyPath(AVPlayer.currentItem.status)).compactMap { $0 }
            )
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, combined) in
                let (timeStatus, itemStatus) = combined
                
                self.timeStatusRelay.accept(timeStatus)
                
                switch (timeStatus, itemStatus) {
                case (.paused, .readyToPlay):
                    self.hideLoading()
                    if self.player.currentItem != nil {
                        self.showControlView()
                        self.videoControlView.isPlayingRelay.accept(false)
                    }
                    
                case (.playing, _):
                    self.hideLoading()
                    self.hideControlView()
                    self.videoControlView.isPlayingRelay.accept(true)
                    
                case (_, .failed):
                    self.hideLoading()
                    self.handleErrorRelay.accept(())
                    
                case (_, .readyToPlay):
                    self.hideLoading()
                    
                default:
                    self.showLoading()
                    self.hideControlView()
                }
                
            })
            .disposed(by: playerBindingsDisposeBag)
    }
    
    private func setupActions() {
        videoControlView.playButton.rx
            .tap
            .withUnretained(self)
            .subscribe { (self, _) in
                if self.player.timeControlStatus == .playing {
                    self.pause()
                    self.stopCountdown()
                } else {
                    self.play()
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    // MARK: - Video player
    func loadVideo(from url: URL, shouldAutoPlay: Bool = true) {
        showLoading()
        hideControlView()
        
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)
        
        NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: item)
                   .observe(on: MainScheduler.instance)
                   .withUnretained(self)
                   .subscribe(onNext: { (self, _) in
                       self.stopCountdown()
                       self.player.seek(to: .zero)
                   })
                   .disposed(by: rx.disposeBag)
        
        if shouldAutoPlay {
            play()
        }
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func reset() {
        pause()
        hideControlView()
    }
    
    private func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @objc private func handleTapGesture() {
        showControlView(withAnimation: true)
        startCountdown()
    }
    
    // MARK: - Timer
    private func startCountdown() {
        stopCountdown()
        
        timerDisposable = Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .map { [weak self] index -> Int in
                guard let self = self else { return 0 }
                return self.countdownSeconds - index
            }
            .take(countdownSeconds + 1)
            .subscribe(
                onCompleted: { [weak self] in
                    self?.timerCompleted()
                }
            )
    }
    
    private func stopCountdown() {
        timerDisposable?.dispose()
    }
    
    private func resetCountdown() {
        stopCountdown()
        startCountdown()
    }
    
    private func timerCompleted() {
        timerDisposable = nil
        hideControlView(withAnimation: true)
    }
    
    private func showControlView(withAnimation: Bool = false) {
        if withAnimation {
            UIView.animate(withDuration: 0.3) {
                self.videoControlView.alpha = 1
            }
        } else {
            videoControlView.alpha = 1
        }
    }
    
    private func hideControlView(withAnimation: Bool = false) {
        if withAnimation {
            UIView.animate(withDuration: 0.5) {
                self.videoControlView.alpha = 0
            }
        } else {
            videoControlView.alpha = 0
        }
    }
}
