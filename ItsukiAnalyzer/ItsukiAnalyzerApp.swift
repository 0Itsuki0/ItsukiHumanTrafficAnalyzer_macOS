//
//  ItsukiAnalyzerApp.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/11.
//

import SwiftUI

@main
struct ItsukiAnalyzerApp: App {
    let trackingModel = TrackingModel()
    var body: some Scene {
        
        WindowGroup {
            ContainerView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .defaultSize(width: 300, height: 200)
        .environmentObject(trackingModel)
        
    }
}
