//
//  BreatheView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-06-25.
//

import SwiftUI

struct BreatheView: View {
  @State private var petCount = 0
  
  var body: some View {
    Button {
      petCount += 1
    } label: {
      Label("Pet the Dog", systemImage: "dog")
    }
    .symbolEffect(.bounce,options: .repeat(90), value: petCount)
    .font(.largeTitle)
  }
}
