//
//  VideoProcessedView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//

import SwiftUI
import Combine

extension VideoProcessedView {
    private func play() {
        let interval = trackingModel.videoManager.minFrameDuration ?? trackingModel.defaultFrameDuration
        timerPublisher = Timer.publish(every: TimeInterval(interval), on: .main, in: .common)
        cancellable = timerPublisher.connect()
    }
    
    
    private func stopPlaying() {
        isPlayingForward = false
        isPlayingBackward = false
        cancellable?.cancel()
    }
    
    private func fastPlay() {
        let interval = (trackingModel.videoManager.minFrameDuration ?? trackingModel.defaultFrameDuration)/2
        timerPublisher = Timer.publish(every: TimeInterval(interval), on: .main, in: .common)
        cancellable = timerPublisher.connect()
    }

    private func updateIndex() {
        if isPlayingForward {
            guard Int(frameIndex) < trackingModel.frames.count - 1 else {
                stopPlaying()
                return
            }
            frameIndex = frameIndex + 1
        }
        if isPlayingBackward {
            guard Int(frameIndex) > 0 else {
                stopPlaying()
                return
            }
            frameIndex = frameIndex - 1
        }
    }
}

struct VideoProcessedView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    @Binding var showSetting: Bool
    
    var size: CGSize
    
    private let boundingBoxPadding: CGFloat = 4.0
    private let boundingBoxStrokeWidth: CGFloat = 2.0
    private let boundingBoxColor: Color = .black
    
    
    // for video playing
    @State private var isPlayingForward: Bool = false
    @State private var isPlayingBackward: Bool = false
    
    @State private var frameIndex: Double = 0.0
    @State private var timerPublisher = Timer.publish(every: .infinity, on: .main, in: .common)
    @State private var cancellable: (any Cancellable)? = nil


    var body: some View {
        
        let dividerWidth: CGFloat = 1.0
        let width = size.width - dividerWidth
        
        let frameCount = trackingModel.frames.count
        
        HStack(spacing: 0) {
            if frameCount >= 1 && Int(frameIndex) < frameCount  {
                let trackedObjectInFrame = (Int(frameIndex) < trackingModel.trackedObjectsPerFrame.count) ? trackingModel.trackedObjectsPerFrame[Int(frameIndex)] : []

                VStack(spacing: 16) {
                    trackingModel.frames[Int(frameIndex)].image?
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .overlay(content: {
                            GeometryReader { geometry in
                                let frameSize = geometry.size
                                                                
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
                    
                    if frameCount > 1 {
                        VStack {
                            Slider(
                                value: $frameIndex,
                                in: 0...Double(frameCount-1),
                                label: {
                                    Text("frame")
                                        .font(.subheadline)
                                }, minimumValueLabel: {
                                    Text("1")
                                }, maximumValueLabel: {
                                    Text("\(frameCount)")
                                })
                            .padding(.horizontal, 16)

                            Text("frame: \(Int(frameIndex + 1))")
                                .font(.subheadline)

                        }
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                stopPlaying()
                                isPlayingBackward = true
                                fastPlay()
                            }, label: {
                                Image(systemName: "backward.fill")
                                    .padding(.all, 4)
                                    .frame(height: 24)

                            })
                            
                            
                            Button(action: {
                                stopPlaying()
                                isPlayingBackward = true
                                play()
                            }, label: {
                                Image(systemName: "play.fill")
                                    .scaleEffect(x: -1)
                                    .padding(.all, 4)
                                    .frame(height: 24)

                            })
                            
                            
                            Button(action: {
                                if isPlayingForward || isPlayingBackward {
                                    stopPlaying()
                                } else {
                                    frameIndex = 0
                                }
                            }, label: {
                                Image(systemName: (isPlayingBackward||isPlayingForward) ? "pause.fill" : "arrow.counterclockwise")
                                    .padding(.all, 4)
                                    .frame(height: 24)


                            })
                            
                            Button(action: {
                                stopPlaying()
                                isPlayingForward = true
                                play()
                            }, label: {
                                Image(systemName: "play.fill")
                                    .padding(.all, 4)
                                    .frame(height: 24)

                            })
                            
                            Button(action: {
                                stopPlaying()
                                isPlayingForward = true
                                fastPlay()
                            }, label: {
                                Image(systemName: "forward.fill")
                                    .padding(.all, 4)
                                    .frame(height: 24)

                            })
                            
                        }
                    }
                    
                    
                }
                .padding()
                .frame(width: width / 2)
                
                
                Divider()
                    .frame(width: dividerWidth)
                
                VStack(spacing: 16) {
                    let currentFrameObjectsCount = trackedObjectInFrame.count
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            showSetting = true
                        }, label: {
                            Text("Tracker Setting")
                                .padding(.all, 4)
                                .frame(height: 24)
                        })
                        
                        Button(action: {
                            trackingModel.reProcessVideo()
                        }, label: {
                            Text("Re-Processing")
                                .padding(.all, 4)
                                .frame(height: 24)
                        })
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    
                    Text("Overview")
                        .font(.title3)
                    
                    Text("Total Detected objects: \(trackingModel.deregisteredObjects.count + trackingModel.trackedObjects.count)")
                    
                    Text("Average Tracked Time: \(String(format: "%.2f", trackingModel.averageTrackedTime)) sec")
                    
                    Divider()
                    
                    Text("Current Frame: frame \(Int(frameIndex + 1))")
                        .font(.title3)
                    
                    Text("Object in Current Frame: \(currentFrameObjectsCount)")
                    
                    Text("Temporarily Disappeared: \(trackingModel.trackedObjects.count - currentFrameObjectsCount)")
                    
                }
                .padding()
                .frame(width: width / 2)
            }

        }
        .onReceive(timerPublisher) { _ in
            updateIndex()
        }
    }
}



#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
