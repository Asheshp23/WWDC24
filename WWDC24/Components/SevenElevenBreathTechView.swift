//
//  SevenElevenBreathTechView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-07-31.
//

import SwiftUI

@available(iOS 18.0, *)
struct SevenElevenBreathTechView: View {
  @State var showBreatheView = false
  @State var startAnimation: Bool = false
  // MARK: Timer Properties
  @State var timerCount: CGFloat = 0
  @State var breatheAction: String = "Breathe In"
  @State var count: Int = 0
  @State var completedCycles: Int = 0
  @State private var showInstructions = true
 
  var meshGradient: some View {
    MeshGradient(
      width: 3,
      height: 3,
      points: [
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.8, 0.2], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
      ], colors: [
        .purple, .indigo, .purple,
        .indigo, .indigo.opacity(0.5), .indigo,
        .purple.opacity(0.5), .indigo, .purple
      ])
    .edgesIgnoringSafeArea(.all)
  }
  
  
  var body: some View {
    ZStack {
      meshGradient
      if showInstructions {
        Text("Breathe in for 7 seconds, hold for 3, breathe out for 11, hold for 3. Repeat.")
          .font(.system(size: 20))
          .foregroundColor(.black)
          .padding()
          .background(Color.white.opacity(0.6))
          .cornerRadius(10)
          .offset(y: -300)
      }
      if showBreatheView {
        Text(breatheAction)
          .font(.system(size: 30, weight: .bold))
          .foregroundColor(.white)
          .offset(y: -320)
        
        ZStack {
          Circle()
            .fill(Color.clear)
            .stroke(Color.white, lineWidth: 5)
            .frame(width: 100, height: 100)
            .shadow(color: .white, radius: 10, x: -5, y: -5)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
          Text("\(count)")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(.white)
        }
        .offset(y: -220)
        
      }
      
      ForEach(0..<8, id: \.self) { i in
        Circle()
          .fill(Color(#colorLiteral(red: 0.837, green: 0.837, blue: 0.837, alpha: 1)).opacity(startAnimation ? 0.5 : 0))
          .frame(width: 150, height: 150)
          .scaleEffect(startAnimation ? 1.1 : 0.05)
          .offset(x: startAnimation ? 75 : 0)
          .rotationEffect(.degrees(Double(i) * 45))
          .rotationEffect(.degrees(startAnimation ? -45 : 0))
      }
      if showBreatheView {
        Text("Completed Cycles: \(completedCycles)")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.white)
          .offset(y: 250)
      }
      
      Button {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
          self.showBreatheView.toggle()
          self.showInstructions.toggle()
          if showBreatheView {
            startBreatheAnimation()
          } else {
            resetBreatheAnimation()
          }
        }
      } label: {
        HStack {
          Image(systemName: showBreatheView ? "stop.fill" : "play.fill")
            .font(.title)
          Text(showBreatheView ? "Stop" : "Start")
            .font(.title2)
            .fontWeight(.bold)
        }
      }
      .offset(y: showBreatheView ? 300 : 0)
      .tint(.white)
      .foregroundStyle(.black)
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity, maxHeight: 70, alignment: .bottom)
    }
    .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
      if showBreatheView {
        handleTimer()
      } else {
        resetTimer()
      }
    }
  }
  private func startBreatheAnimation() {
    withAnimation(.easeInOut(duration: 7).delay(0.05)) {
      startAnimation = true
    }
  }
  
  private func resetBreatheAnimation() {
    startAnimation = false
  }
  
  private func handleTimer() {
    let maxTime: CGFloat
    let holdTime: CGFloat = 3
    
    switch breatheAction {
    case "Breathe In":
      maxTime = 7
    case "Hold After Inhale", "Hold After Exhale":
      maxTime = holdTime
    case "Breathe Out":
      maxTime = 11
    default:
      maxTime = 0
    }
    
    if timerCount >= maxTime {
      timerCount = 0
      updateBreatheAction()
    } else {
      timerCount += 0.01
      count = Int(timerCount) + 1
    }
  }
  
  private func updateBreatheAction() {
    switch breatheAction {
    case "Breathe In":
      breatheAction = "Hold After Inhale"
    case "Hold After Inhale":
      breatheAction = "Breathe Out"
      withAnimation(.easeInOut(duration: 11)) {
        startAnimation = false
      }
    case "Breathe Out":
      breatheAction = "Hold After Exhale"
    case "Hold After Exhale":
      breatheAction = "Breathe In"
      completedCycles += 1
      withAnimation(.easeInOut(duration: 7)) {
        startAnimation = true
      }
    default:
      breatheAction = "Breathe In"
    }
  }
  
  private func resetTimer() {
    timerCount = 0
    count = 0
  }
}

#Preview {
  if #available(iOS 18.0, *) {
    SevenElevenBreathTechView()
  } else {
    // Fallback on earlier versions
  }
}
