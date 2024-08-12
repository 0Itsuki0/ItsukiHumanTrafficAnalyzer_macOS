//
//  VideoLoadedView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//

import SwiftUI

struct VideoLoadedView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    @Binding var showSetting: Bool
    
    @State private var frameCount: Int = 0
    @State private var distance: Float = 0

    
    var size: CGSize

    var body: some View {
        let dividerWidth: CGFloat = 1.0
        let width = size.width - dividerWidth

        HStack(spacing: 0) {
            if let firstFrame = trackingModel.frames.first {
                VStack(spacing: 16) {
                    firstFrame.image?
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()

                }
                .padding()
                .frame(width: width / 2)


                Divider()
                    .frame(width: dividerWidth)
                
                VStack(spacing: 16) {
                    
                    
                    Text("Tracker Setting")
                        .font(.title3)
                    
                    HStack(spacing: 16) {
                        Text("Max Disappeared Frame Count \nto deregister a tracked object.")
                        
                        TextField("20", value: $frameCount, format: .number)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .frame(width: 64)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray.opacity(0.2))
                            )
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 16) {
                        Text("Max Normalized Distance \nto consider 2 detected objects \nto be different objects.")
                        
                        TextField("0.2", value: $distance, format: .number)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .frame(width: 64)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray.opacity(0.2))
                            )
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    Button(action: {
                        trackingModel.processVideo()
                    }, label: {
                        Text("Start Processing")
                            .padding(.all, 4)
                            .frame(height: 24)
                    })
                                        
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding()
                .frame(width: width / 2)


            }
        }
        .onAppear {
            self.frameCount = trackingModel.tracker.maxDisappearedFrameCount
            self.distance = Float(trackingModel.tracker.maxNormalizedDistance)
        }
        .onChange(of: frameCount, {
            if frameCount <= 0 {
                self.frameCount = trackingModel.tracker.maxDisappearedFrameCount
            } else {
                trackingModel.tracker.maxDisappearedFrameCount = self.frameCount
            }
        })
        .onChange(of: distance, {
            if distance > sqrt(2) {
                self.distance = sqrt(2)
                trackingModel.tracker.maxNormalizedDistance = sqrt(2)
            } else if distance <= 0 {
                self.distance = 0
                trackingModel.tracker.maxNormalizedDistance = 0
            } else {
                trackingModel.tracker.maxNormalizedDistance = CGFloat(self.distance)
            }
        })
    }
}


#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
