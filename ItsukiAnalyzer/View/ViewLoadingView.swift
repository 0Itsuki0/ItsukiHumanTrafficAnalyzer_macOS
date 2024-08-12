//
//  ViewLoadingView.swift
//  ItsukiAnalyzer
//
//  Created by Itsuki on 2024/08/12.
//


import SwiftUI

struct LoadingView: View {
    @State private var rotationAngle = 0.0
    private let ringSize: CGFloat = 80
    private let colors: [Color] = [.white, .white.opacity(0.2)]

    var body: some View {

        ZStack {
            Circle()
               .stroke(
                   AngularGradient(
                       gradient: Gradient(colors: colors),
                       center: .center,
                       startAngle: .degrees(0),
                       endAngle: .degrees(360)
                   ),
                   style: StrokeStyle(lineWidth: 16, lineCap: .round)

               )
               .frame(width: ringSize, height: ringSize)

            Circle()
                .frame(width: 16, height: 16)
                .foregroundColor(colors[0])
                .offset(x: ringSize/2)

        }
        .rotationEffect(.degrees(rotationAngle))
        .padding(.horizontal, 80)
        .padding(.vertical, 50)
        .background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.3)))
        .onAppear {
            withAnimation(.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)) {
                    rotationAngle = 360.0
                }
        }
        .onDisappear{
            rotationAngle = 0.0
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}


#Preview {
    ContainerView()
        .environmentObject(TrackingModel())
}
