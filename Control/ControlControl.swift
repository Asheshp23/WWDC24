//
//  ControlControl.swift
//  Control
//
//  Created by Ashesh Patel on 2024-06-17.
//

import AppIntents
import SwiftUI
import WidgetKit

struct ControlControl: ControlWidget {
    static let kind: String = "com.WWDC24.Control"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
              SharedTimerManager.shared.isOn ? "Stop sprinkler" : "Start sprinkler",
                isOn: SharedTimerManager.shared.isOn,
                action: StartTimerIntent(),
                valueLabel: { isRunning in
                  Label(isRunning ? "On" : "Off", systemImage: isRunning ? "sprinkler.and.droplets.fill" : "sprinkler.and.droplets" )
                }
            )
        }
        .displayName("Sprinkler")
        .description("A an example control that runs a sprinkler.")
    }
}

extension ControlControl {
    struct Provider: ControlValueProvider {
        var previewValue: Bool {
            false
        }

        func currentValue() async throws -> Bool {
            let isRunning = true // Check if the timer is running
            return isRunning
        }
    }
}

struct StartTimerIntent: SetValueIntent {
    static var title: LocalizedStringResource { "Start a sprinkler" }

    @Parameter(title: "Sprinkler is running")
    var value: Bool

    func perform() async throws -> some IntentResult {
        // Start / stop the timer based on `value`.
      Task { @MainActor in
        SharedTimerManager.shared.isOn = value
      }
        return .result()
    }
}

class SharedTimerManager {
  @MainActor static let shared = SharedTimerManager()
  var isOn: Bool = false
  
  func startTimer() {
    isOn.toggle()
  }
}
