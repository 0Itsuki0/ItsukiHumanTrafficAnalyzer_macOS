//
//  SettingView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/11.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var trackingModel: TrackingModel
    
    @Binding var showSetting: Bool
    @State private var frameCount: Int = 0
    @State private var distance: Float = 0
    
    var body: some View {
        VStack(spacing: 32) {
            
            HStack {
                Text("Max Disappeared Frame Count \nto deregister a tracked object.")
                
                TextField("20", value: $frameCount, format: .number)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .frame(width: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .background(.black)

            HStack {
                Text("Max Normalized Distance to consider \n2 detected objects to be different objects.")
//                        .frame(maxWidth: .infinity)
                TextField("0.2", value: $distance, format: .number)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .frame(width: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.horizontal)
                    
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .fixedSize(horizontal: true, vertical: true)
        .padding(.all, 24)
        .padding(.top, 16)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                showSetting = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            })
        })
        .padding(.all, 24)
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
    SettingView(showSetting: .constant(true))
        .environmentObject(TrackingModel())
}
