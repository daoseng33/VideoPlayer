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
    let playButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        let image = UIImage(systemSymbol: .playCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        
        // Add shadow effect
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.5
        
        // Ensure shadow is visible if the image has transparent parts
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        
        return button
    }()
    
    let controlPannelView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        return view
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
        
        addSubview(controlPannelView)
        controlPannelView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(35)
        }
    }
    
    func changePlayButtonStatus(isPlaying: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        var image: UIImage!
        
        if isPlaying {
            image = UIImage(systemSymbol: .pauseCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            image = UIImage(systemSymbol: .playCircle, withConfiguration: symbolConfig).withRenderingMode(.alwaysOriginal).withTintColor(.white)
        }
        
        playButton.setImage(image, for: .normal)
    }
}
