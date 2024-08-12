//
//  VideoProcessingView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//

import SwiftUI

struct VideoProcessingView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    @Binding var showSetting: Bool
    
    var size: CGSize
    
    private let boundingBoxPadding: CGFloat = 4.0
    private let boundingBoxStrokeWidth: CGFloat = 2.0
    private let boundingBoxColor: Color = .black

    var body: some View {
        

        let dividerWidth: CGFloat = 1.0
        let width = size.width - dividerWidth
        

        HStack(spacing: 0) {
            VStack(spacing: 16) {
                trackingModel.frames.last?.image?
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .overlay(content: {
                        GeometryReader { geometry in
                            let frameSize = geometry.size
                            let trackedObjectInFrame = trackingModel.trackedObjectsPerFrame.last ?? []
                            
                            ForEach(trackedObjectInFrame) { object in
                                let rect = trackingModel.convertRect(normalizedRect: object.rect, imageSize: frameSize)
                                if rect != .zero {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(boundingBoxColor, style: .init(lineWidth: boundingBoxStrokeWidth))
                                        .frame(width: rect.width + boundingBoxPadding*2, height: rect.height + boundingBoxPadding*2)
                                        .overlay(alignment: .topLeading, content: {
                                            Text("ID: \(object.id)")
                                                .foregroundStyle(boundingBoxColor)
                                                .offset(y: -16)
                                        })

                                        .position(CGPoint(x: rect.midX, y: rect.midY))

                                }
                                
                            }
                        }
                    })
                
                ProgressView(value: trackingModel.fractionProcessed, total: 1.0, label: {
                    Text("Processing...")
                }, currentValueLabel: {
                    Text("\(Int(trackingModel.fractionProcessed * 100))%")
                })
                .progressViewStyle(.linear)
                

            }
            .padding()
            .frame(width: width / 2)


            Divider()
                .frame(width: dividerWidth)
            
            VStack(spacing: 16) {
//                Text("Processing...")
//                
//                Divider()
//                
                let currentTrackingCount = trackingModel.trackedObjects.count
                let currentFrameObjectsCount = (trackingModel.trackedObjectsPerFrame.last ?? []).count

                Text("Overview")
                    .font(.title3)
                
                Text("Currently Tracking: \(currentTrackingCount)")
                
                Text("Deregistered: \(trackingModel.deregisteredObjects.count)")
                
                Text("Average Tracked Time: \(String(format: "%.2f", trackingModel.averageTrackedTime)) sec")
                
                Divider()

                Text("Current Frame")
                    .font(.title3)

                Text("Object in Current Frame: \(currentFrameObjectsCount)")

                Text("Temporarily Disappeared: \(currentTrackingCount - currentFrameObjectsCount)")

            }
            .padding()
            .frame(width: width / 2)

        }
    }
}



#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}

