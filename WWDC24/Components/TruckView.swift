//
//  TruckView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-06-25.
//
import SwiftUI

struct TruckView: View {
  @State private var driveForward = true

  private var driveAnimation: Animation {
    .easeInOut
    .repeatCount(1, autoreverses: true)
    .speed(0.5)
  }
  var body: some View {
    VStack(alignment: driveForward ? .leading : .trailing, spacing: 40) {
      Image(systemName: "box.truck")
        .font(.system(size: 48))
        .animation(driveAnimation, value: driveForward)
      
      HStack {
        Spacer()
        Button("Animate") {
          driveForward = false
        }
        Spacer()
      }
    }
  }
}
