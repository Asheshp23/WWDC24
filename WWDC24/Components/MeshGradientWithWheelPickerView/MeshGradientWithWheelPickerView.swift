//
//  MeshGradientWithWheelPickerView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-06-19.
//
import SwiftUI

@available(iOS 18.0, *)
struct MeshGradientWithWheelPickerView: View {
  @State var selectedValue: CGFloat = 0
  
  var meshGradient: some View {
    MeshGradient(
      width: 3,
      height: 3,
      points: [
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.8, 0.2], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
      ], colors: [
        .white, .pink, .white,
        .white, .pink, .white,
        .white, .pink, .white
      ])
    .edgesIgnoringSafeArea(.all)
  }
  
  var text: some View {
    Text("\(Int(selectedValue / 10))")
      .font(.largeTitle.bold())
      .foregroundColor(.white)
      .padding()
      .contentTransition(.numericText(value: selectedValue / 10))
  }
  
  var body: some View {
    ZStack {
      meshGradient
      VStack {
        text
        WheelPickerView(selectedValue: $selectedValue)
          .frame(height: 100)
          .background(
            RoundedRectangle(cornerRadius: 16.0)
              .fill(Color.black)
              .shadow(radius: 10)
          )
          .padding(.horizontal)
      }
    }
  }
}

#Preview {
  if #available(iOS 18.0, *) {
    MeshGradientWithWheelPickerView()
  } else {
    // Fallback on earlier versions
  }
}
