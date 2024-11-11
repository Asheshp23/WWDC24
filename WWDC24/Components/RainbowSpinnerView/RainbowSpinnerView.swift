//
//  RainbowSpinnerView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-07-18.
//
import SwiftUI

struct RainbowSpinnerView: View {
  let gradientColors: [Color] = [.red,.orange,.yellow,.green,.blue, .purple, .pink]
  @State var degrees:Double = 0
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 25)
        .frame(width: 150, height: 150)
        .foregroundStyle(.gray.opacity (0.3))
      Circle()
        .stroke(lineWidth: 25)
        .frame(width: 150, height: 150)
        .foregroundStyle(AngularGradient.init(
          gradient: Gradient(colors: gradientColors),
          center: .center))
        .mask {
          Circle()
            .trim(from: 0, to: 0.15)
            .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin:. round))
            .rotationEffect(.degrees(degrees))
        }
        .onAppear {
          withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            degrees += 360
          }
        }
    }
  }
}

#Preview {
  RainbowSpinnerView()
}
