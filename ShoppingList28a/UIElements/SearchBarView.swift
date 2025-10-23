import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск товаров", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                })
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.slFramesBackground))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}
