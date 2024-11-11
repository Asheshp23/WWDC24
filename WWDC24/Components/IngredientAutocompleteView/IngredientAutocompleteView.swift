import SwiftUI

struct Ingredient {
  let name: String
}

struct Category {
  let name: String
  let ingredients: [Ingredient]
}

struct IngredientAutocompleteView: View {
  @State var ingredientName: String = ""
  @State var ingredientType: IngredientType = .dairy
  @State private var ingredientsByCategory: [String: [String]] = [:]
  @State private var filteredIngredientsByCategory: [String: [String]] = [:]
  @State private var showDropdown: Bool = false
  @State private var showError: Bool = false
  @FocusState private var ingredientFieldIsFocused: Bool
  @State private var showAddIngredientView: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          TextField("Enter ingredient", text: $ingredientName)
            .padding(.leading, 10)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onChange(of: ingredientName) { newValue, oldValue in
              filterIngredients(with: newValue)
            }
            .focused($ingredientFieldIsFocused)
            .onSubmit {
              validateIngredient()
            }
            .overlay(
              HStack {
                Spacer()
                if !ingredientName.isEmpty {
                  Button(action: {
                    ingredientName = ""
                    showDropdown = false
                  }) {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.gray)
                      .padding(.trailing, 10)
                  }
                }
              }
            )
          
          if ingredientFieldIsFocused {
            Button("Cancel") {
              ingredientFieldIsFocused = false
              showDropdown = false
            }
            .padding(.leading, 8)
          }
        }
        
        if showDropdown && !filteredIngredientsByCategory.isEmpty {
          List {
            ForEach(filteredIngredientsByCategory.keys.sorted(), id: \.self) { category in
              Section(header: Text(category).font(.headline)) {
                ForEach(filteredIngredientsByCategory[category]!, id: \.self) { ingredient in
                  Text(ingredient)
                    .padding(.vertical, 8)
                    .onTapGesture {
                      selectIngredient(ingredient)
                    }
                }
              }
            }
          }
          .listStyle(PlainListStyle())
          .background(Color.white)
          .cornerRadius(8)
          .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
          .transition(.opacity.combined(with: .slide))
          .animation(.easeInOut, value: showDropdown)
        }
        
        if showError {
          Text("Please select a valid ingredient from the list.")
            .foregroundColor(.red)
            .padding(.top, 10)
        }
      }
      .onAppear {
        loadIngredients()
      }
    }
  }
  
  @MainActor
  private func filterIngredients(with query: String) {
    if query.isEmpty {
      filteredIngredientsByCategory = [:]
      showDropdown = false
    } else {
      showDropdown = true
      filteredIngredientsByCategory = ingredientsByCategory.mapValues { ingredients in
        ingredients.filter { $0.localizedCaseInsensitiveContains(query) }
      }.filter { !$0.value.isEmpty }
      print(filteredIngredientsByCategory.count)
      print(query)
      
    }
  }
  
  private func selectIngredient(_ ingredient: String) {
    ingredientName = ingredient
    showDropdown = false
    ingredientFieldIsFocused = false
    showError = false
  }
  
  private func validateIngredient() {
    let allIngredients = ingredientsByCategory.flatMap { $0.value }
    if !allIngredients.contains(ingredientName) {
      ingredientName = ""
      showError = true
    } else {
      showError = false
    }
  }
  
  private func loadIngredients() {
    self.ingredientsByCategory = parseCSV(fileName: "ingredients2")
  }
  
  private func parseCSV(fileName: String) -> [String: [String]] {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "csv") else {
      print("CSV file not found")
      return [:]
    }
    
    do {
      let data = try String(contentsOfFile: path)
      let rows = data.components(separatedBy: "\n")
      var ingredientsByCategory = [String: [String]]()
      
      for line in rows {
        guard !line.isEmpty else { continue }
        let components = line.components(separatedBy: ",")
        guard let category = components.first else { continue }
        
        let ingredients = components.dropFirst().map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        if !ingredients.isEmpty {
          ingredientsByCategory[category, default: []].append(contentsOf: ingredients.filter { !$0.isEmpty })
        }
      }
      print(ingredientsByCategory.count)
      return ingredientsByCategory
    } catch {
      print("Error reading CSV file: \(error)")
      return [:]
    }
  }
}

struct AddIngredientView: View {
  @State var vm = AddIngredientVM()
  @Environment(\.dismiss) var dismiss
  @Environment(\.colorScheme) private var colorScheme
  
  var ingredientMeasurementUnitView: some View {
    Picker("", selection: $vm.selectedMeasurementUnit) {
      ForEach(MeasurementUnit.allCases) { unit in
        Text(unit.rawValue)
          .tag(unit)
      }
    }
    .pickerStyle(MenuPickerStyle())
    .frame(maxWidth: 100)
  }
  
  var ingredientQuantityView: some View {
    Section(header: Text("Ingredient quantity")) {
      HStack {
        TextField("0.0", text: $vm.ingredientQuantity)
          .frame(maxWidth: .infinity)
          .keyboardType(.decimalPad)
          
          .padding()
        ingredientMeasurementUnitView
      }
    }
  }
  
  var ingredientTypeView: some View {
    Section(header: Text("Ingredient Type")) {
      Picker("", selection: $vm.selectedIngredientType) {
        ForEach(IngredientType.allCases) { ingredientType in
          Text(ingredientType.rawValue)
            .tag(ingredientType)
        }
      }
      .pickerStyle(WheelPickerStyle())
    }
  }
  
  var addButtonView: some View {
    Button("Add") {
      addIngredient()
    }
    .bold()
    .frame(maxWidth: .infinity, alignment: .trailing)
    .buttonStyle(.borderedProminent)
    .foregroundStyle(colorScheme == .dark ? .black : .white)
    .tint(colorScheme == .dark ? .white : .black)
    .disabled(vm.ingredientName.isEmpty || vm.ingredientQuantity.isEmpty)
  }
  
  var addIngredientFormView: some View {
    Form {
      ingredientQuantityView
      addButtonView
  }
}
  
  var body: some View {
      addIngredientFormView
  }
  
  func addIngredient() {
    Task { @MainActor in
      dismiss()
    }
  }
}

@Observable
class AddIngredientVM {
   var ingredientName: String = ""
  var ingredientQuantity: String = ""
   var selectedMeasurementUnit: MeasurementUnit = .grams
   var selectedIngredientType: IngredientType = .vegetable
  
  func addIngredient(using context: Any) {
    // Implement the logic to add the ingredient to the context
  }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
  case grams, kilograms, ounces, pounds, cups, teaspoons, tablespoons
  
  var id: String { self.rawValue }
}

enum IngredientType: String, CaseIterable, Identifiable {
  case vegetable, fruit, meat, dairy, grain, spice, other
  
  var id: String { self.rawValue }
}


struct IngredientAutocompleteView_Previews: PreviewProvider {
  static var previews: some View {
    IngredientAutocompleteView()
      .preferredColorScheme(.light)
      .previewDevice("iPhone 13")
  }
}

struct AddIngredientView_Previews: PreviewProvider {
  static var previews: some View {
    AddIngredientView()
  }
}
