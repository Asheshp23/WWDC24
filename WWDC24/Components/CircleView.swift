//
//  CircleView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-06-25.
//
import SwiftUI

struct CircleView: View {
  @State private var scale = 1.0
  
  var body: some View {
    VStack {
      Circle()
        .stroke(lineWidth: 3.0)
        .scaleEffect(scale)
        .animation(
          .timingCurve(0.1, 0.75, 0.85, 0.35, duration: 2.0),
          value: scale)
        .onAppear {
          if scale == 1.0 {
            scale = 0.1
          }
        }
        .onChange(of: scale) { oldValue, newValue in
          if newValue == 0.1 {
            scale = 0.5
        }
      }
    }
  }
}

#Preview {
  CircleView()
    .padding()
}
