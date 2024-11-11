//
//  KeyframeAnimationView.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-11-11.
//
import SwiftUI

struct AnimationProperties {
  var translation = 0.0
  var verticalStretch = 1.0
}

struct KeyframeAnimationView: View {

    var totalDuration = 1.0
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .foregroundStyle(.blue)
            .frame(width: 100, height: 100)
            .keyframeAnimator(initialValue: AnimationProperties(), repeating: true) { content, value in
                content
                    .scaleEffect(.init(width: 1, height: value.verticalStretch), anchor: .bottom)
                    .offset(y: value.translation)
            } keyframes: { _ in
                KeyframeTrack(\.verticalStretch) {
                    SpringKeyframe(0.6, duration: 0.2 * totalDuration)
                    CubicKeyframe(1, duration: 0.2 * totalDuration)
                    CubicKeyframe(1.2, duration: 0.6 * totalDuration)
                    CubicKeyframe(1.1, duration: 0.25 * totalDuration)
                    SpringKeyframe(1, duration: 0.25 * totalDuration)
                }

                KeyframeTrack(\.translation) {
                    CubicKeyframe(0, duration: 0.2 * totalDuration)
                    CubicKeyframe(-100, duration: 0.4 * totalDuration)
                    CubicKeyframe(-100, duration: 0.4 * totalDuration)
                    CubicKeyframe(0, duration: 0.5 * totalDuration)
                }
            }
    }

}
