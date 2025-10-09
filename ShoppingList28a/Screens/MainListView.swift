import SwiftUI

struct MainListView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Мои списки")
                    .font(.title1)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    print("Кнопка 'Три точки' нажата")
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundStyle(.slBlackFontsTitle)
                        .padding(10)
                })
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 8)
        }
        VStack {
            Spacer()
            
            Image("ImagemainScreen")
            
            VStack(spacing: 8) {
                Text("Давайте спланируем покупки!")
                    .font(.title3)
                Text("Создайте свой первый список")
                    .font(.appBody)
            }
            .padding()
            
            Spacer()
            
            PrimaryButton(title: "Создать список") {
                print("Кнопка 'Создать список' нажата")
            }
            .padding(20)
        }
    }
}

#Preview {
    MainListView()
}
