import SwiftUI

struct ContentView: View {
  @State var todoItems: [TodoItem] = []
  var body: some View {
    VStack {
      TodoList(items: $todoItems)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
