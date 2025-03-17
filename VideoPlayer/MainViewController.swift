//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/17.
//

import SwiftUI
import UIKit

final class MainViewController: UIViewController {
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
