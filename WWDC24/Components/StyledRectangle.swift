//
//  StyledRectangle.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-07-18.
//

import SwiftUI

struct StyledRectangle: View {
  @State var rotation:CGFloat = 0.0
  
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(.gray)
          .frame(width: 200, height: 240)
        RoundedRectangle(cornerRadius: 20)
          .frame(width: 130, height: 300)
          .foregroundStyle(.blue)
          .rotationEffect(.degrees(rotation))
          .mask {
            RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 7)
              .frame(width: 193, height: 235)
          }
          .onAppear {
            withAnimation(.linear(duration: 4)
              .repeatForever(autoreverses: false)){ rotation = 360 }
          }
      }
    }
}

#Preview {
    StyledRectangle()
}
