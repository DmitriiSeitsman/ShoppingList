import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var items: [GroceryItem]
    @StateObject private var viewModel = AddItemViewModel()
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                Button("Отменить") {
                    viewModel.reset()
                    dismiss()
                }
                .font(.appBody)
                .foregroundColor(.slGrey)
                
                Spacer()
                
                Text("Создание товара")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.slBlackFontsTitle)
                
                Spacer()
                
                Button("Готово") {
                    if let item = viewModel.createItem(items: items) {
                        items.append(item)
                        viewModel.reset()
                        dismiss()
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor((viewModel.name.isEmpty || viewModel.quantity.isEmpty || Int(viewModel.quantity) == nil) ? .slGrey : .slTurquoise)
                .disabled(viewModel.nameError && viewModel.quantityError && viewModel.name.isEmpty && viewModel.quantity.isEmpty && Int(viewModel.quantity) == nil)
            }
            .padding(.horizontal, 16)
            .padding(.top, 21)
            
            VStack(spacing: 20) {
                BaseTextField(
                    placeholder: "Название товара",
                    text: $viewModel.name,
                    isError: viewModel.nameError,
                    errorText: viewModel.nameErrorText
                )
                
                HStack(spacing: -12) {
                    BaseTextField(
                        placeholder: "Количество",
                        text: $viewModel.quantity,
                        isError: viewModel.quantityError,
                        errorText: viewModel.quantityErrorText
                    )
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity)
                    
                    ZStack {
                        Text("Ед.изм.:")
                            .font(.appBody)
                            .foregroundColor(.slGreySystem)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .frame(height: 54)
                            .background(Color.slFramesBackground)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        
                        Menu {
                            ForEach(viewModel.availableUnits, id: \.self) { unit in
                                Button(unit) {
                                    viewModel.unit = unit
                                }
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text(viewModel.unit)
                                    .font(.appBody)
                                    .foregroundColor(.slTurquoise)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.system(size: 17))
                                    .foregroundColor(.slTurquoise)
                            }
                            .padding(.horizontal, 32)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .background(Color.slBackground)
        .animation(.easeInOut(duration: 0.2), value: viewModel.name)
        .onDisappear {
            viewModel.reset()
        }
    }
}

#Preview() {
// в симуляторе в поле количество вылезает нам пад и буквы там ввести нельзя
        AddItemView(items: .constant([
            GroceryItem(name: "Молоко", isPurchased: true, quantity: 1, unit: "л")
        ]))
    
}
