import SwiftUI

struct WheelPickerView: View {
  @Binding var selectedValue: CGFloat
  @State var isLoaded: Bool = false
  
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      let padding = size.width / 2
      
      ScrollView(.horizontal) {
        HStack(spacing: 5) {
          ForEach(0...1000, id: \.self) { number in
            let remainder = number % 10
            Divider()
              .background(remainder == 0 ? (selectedValue >= CGFloat(number) ? .red : Color.white) :
                            (selectedValue >= CGFloat(number) ? .pink : .white))
              .frame(width: 0,
                     height: remainder == 0 ? 20 :
                      number % 5 == 0 ? 10 :
                      5, alignment: .bottom)
              .frame(maxHeight: 20, alignment:
                  .bottom)
              .offset(y: 20)
              .overlay(alignment: .top) {
                if remainder == 0 {
                  Text("\((number / 10))")
                    .font(.title)
                    .textScale(.secondary)
                    .fixedSize()
                    .fontWeight(.semibold)
                    .offset(y: -20)
                    .foregroundStyle(selectedValue >= CGFloat(number) ? .white : Color(red: 0.448, green: 0.484, blue: 0.476))
                }
              }
              .visualEffect { content, proxy in
                return content
                  .scaleEffect(1.5)
              }
          }
        }
        .frame(height: size.height)
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.viewAligned)
      .scrollPosition(id: .init(get: {
        let value: Int? = isLoaded ? Int(selectedValue) : 0
        return value
      }, set: { newValue in
        if let newValue { self.selectedValue = CGFloat(newValue) }
      }))
      .overlay(alignment: .top) {
        HStack {
          Image(systemName: "triangle.fill")
            .foregroundStyle(.pink)
            .rotationEffect(.degrees(180))
            .frame(width: 20, height: 20)
            .offset(y: -8)
        }
      }
      .scrollIndicators(.hidden)
      .safeAreaPadding(.horizontal, padding)
      .onAppear {
        if !isLoaded { isLoaded = true }
      }
    }
  }
}

#Preview {
  WheelPickerView(selectedValue: .constant(0))
    .frame(height: 100)
    .background(.black)
}
