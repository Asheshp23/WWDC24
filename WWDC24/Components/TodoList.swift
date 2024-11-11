//
//  TodoList.swift
//  WWDC24
//
//  Created by Ashesh Patel on 2024-07-25.
//
import SwiftUI

struct TodoItem: Identifiable {
  let id: UUID
  var title: String
}

struct TodoList: View {
  @Binding var items: [TodoItem]
  
  var body: some View {
    NavigationView {
      VStack {
        List {
          ForEach($items) { $item in
            TextField("Title", text: $item.title)
          }
        }
        TodoItemAddButton {
         let newItem = TodoItem(id: UUID(), title: "new item")
          items.append(newItem)
        }
      }
      .navigationTitle("Todo list")
    }
  }
}
