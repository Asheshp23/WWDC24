//
//  TodoItemAddButton.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-07-25.
//
import SwiftUI

struct TodoItemAddButton: View {
  var action: () -> Void
  var body: some View {
    Button(action: action) {
      Text("Add item")
    }
  }
}
