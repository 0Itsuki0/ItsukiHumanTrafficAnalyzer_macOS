//
//  VideoSelectionView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/11.
//

import SwiftUI

struct VideoImportView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    @Binding var showImporter: Bool

    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(spacing: 24) {
                Text("Import A Video to Start!")
                    .font(.system(size: 16))

                Button(action: {
                    showImporter = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 100, height: 100)
                })

            }
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}


#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
