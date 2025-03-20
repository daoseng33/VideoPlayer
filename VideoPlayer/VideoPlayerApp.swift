//
//  VideoPlayerApp.swift
//  VideoPlayer
//
//  Created by DAO on 2025/3/14.
//

import SwiftUI

@main
struct VideoPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewControllerRepresentable()
                .ignoresSafeArea()
        }
    }
}
