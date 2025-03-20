//
//  VideoControlView.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/18.
//

import UIKit
import SnapKit
import SFSafeSymbols

final class VideoControlView: UIView {
    // MARK: - UI
    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        let image = UIImage(systemSymbol: .playCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        addShadow(to: button)
        return button
    }()
    
    lazy var goForwardButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let image = UIImage(systemSymbol: ._10ArrowTriangleheadClockwise, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        addShadow(to: button)
        return button
    }()
    
    lazy var goBackwardButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let image = UIImage(systemSymbol: ._10ArrowTriangleheadCounterclockwise, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        addShadow(to: button)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [volumeButton, timeLabel, fullScreenButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var volumeButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemSymbol: .speakerWave2Fill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        addShadow(to: button)
        return button
    }()
    
    lazy var fullScreenButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemSymbol: .arrowDownLeftAndArrowUpRightRectangleFill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        addShadow(to: button)
        return button
    }()
    
    lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = .white
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        addShadow(to: slider)
        return slider
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "00:00 / 00:00"
        addShadow(to: label)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(goForwardButton)
        goForwardButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(70)
        }
        
        addSubview(goBackwardButton)
        goBackwardButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-70)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        addSubview(progressSlider)
        progressSlider.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(stackView.snp.top)
        }
        
        volumeButton.snp.makeConstraints {
            $0.width.equalTo(44)
        }
        
        fullScreenButton.snp.makeConstraints {
            $0.width.equalTo(44)
        }
    }
    
    // MARK: - Change button status
    func changePlayButtonMode(isPlaying: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        var image: UIImage!
        
        if isPlaying {
            image = UIImage(systemSymbol: .pauseCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            image = UIImage(systemSymbol: .playCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        }
        
        playButton.setImage(image, for: .normal)
    }
    
    func changeVolumeButtonMode(isMuted: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        var image: UIImage!
        
        if isMuted {
            image = UIImage(systemSymbol: .speakerSlashFill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            image = UIImage(systemSymbol: .speakerWave2Fill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        }
        
        volumeButton.setImage(image, for: .normal)
    }
    
    func changeFullScreenMode(isFullScreen: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        var image: UIImage!
        
        if isFullScreen {
            image = UIImage(systemSymbol: .arrowUpRightAndArrowDownLeftRectangleFill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            image = UIImage(systemSymbol: .arrowDownLeftAndArrowUpRightRectangleFill, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        }
        
        fullScreenButton.setImage(image, for: .normal)
    }
    
    private func addShadow(to view: UIView) {
        // Add shadow effect
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.5
        
        // Ensure shadow is visible if the image has transparent parts
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
