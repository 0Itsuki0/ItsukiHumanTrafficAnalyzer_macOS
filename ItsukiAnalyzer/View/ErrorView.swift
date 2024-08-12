//
//  ErrorView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//


import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    var size: CGSize

    var body: some View {            
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 70))
            
            if let message = trackingModel.error?.message {
                Text(message)
                    .font(.system(size: 16))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: size.width/3)
            }
        }
        .padding(.all, 16)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {
                trackingModel.error = nil
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
            })
        })
        .padding(.all, 16)
        .background(RoundedRectangle(cornerRadius: 8).fill(.gray))

        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
