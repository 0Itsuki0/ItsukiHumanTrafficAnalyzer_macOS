//
//  VisionManager.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/11.
//


import SwiftUI
import Vision


class VisionManager {

    private var request: DetectHumanRectanglesRequest
    
    init() {
        var request = DetectHumanRectanglesRequest()
        request.upperBodyOnly = true // requires only detecting a human upper body to produce a result.
        self.request = request
    }

    func processHumanDetection(_ cgImage: CGImage) async throws -> [HumanObservation] {
        let observations = try await request.perform(on: cgImage)
        return observations
    }
}
