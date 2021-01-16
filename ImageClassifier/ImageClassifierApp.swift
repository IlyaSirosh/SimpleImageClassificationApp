//
//  ImageClassifierApp.swift
//  ImageClassifier
//
//  Created by Illya Sirosh on 16.01.2021.
//

import SwiftUI

@main
struct ImageClassifierApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ClassificationService(with: MobileNetV2().model))
        }
    }
}
