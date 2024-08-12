//
//  ContainerView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//

import SwiftUI

struct ContainerView: View {
    @EnvironmentObject var trackingModel: TrackingModel
    @State private var showSetting = false
    @State private var showImporter = false

    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                Text("Itsuki Analyzer")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                if trackingModel.processingState != .none && trackingModel.processingState != .loading && trackingModel.processingState != .processing {
                    Button(action: {
                        showImporter = true
                    }, label: {
                        Text("Import A different video")
                            .padding(.all, 4)
                            .frame(height: 24)
                    })
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.2))
            
            VStack {

                GeometryReader(content: { geometry in
                    ZStack {
                        switch trackingModel.processingState {
                        case .none:
                            VideoImportView(showImporter: $showImporter)
                        case .loading:
                            LoadingView()
                        case .loaded:
                            VideoLoadedView(showSetting: $showSetting, size: geometry.size)
                        case .processing:
                            VideoProcessingView(showSetting: $showSetting, size: geometry.size)
                        case .processed:
                            VideoProcessedView(showSetting: $showSetting, size: geometry.size)
                        }
                        
                        if trackingModel.error != nil {
                            ErrorView(size: geometry.size)
                        }
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            }
            .frame(maxHeight: .infinity, alignment: .center)

        }
        .frame(minWidth: 560, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showSetting , content: {
            SettingView(showSetting: $showSetting)
                .environmentObject(trackingModel)
        })
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.movie],
            allowsMultipleSelection: false
        ) { result in
            trackingModel.processFileImporterResult(result)
        }
    }
}



#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
