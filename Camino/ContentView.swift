import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                ExploreView()
                    .tag(0)
                
                TripsView()
                    .tag(1)
                
                Text("Profile!")
                    .tag(2)
            }
            
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(Color("TabBar"))
            .cornerRadius(35)
            .padding(.horizontal, 26)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    ContentView()
}
