import SwiftUI

struct ContentView: View {
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ExploreView()
                        .tag(0)
                    
                    TripsView()
                        .tag(1)
                    
                    ProfileView()
                        .tag(2)
                }
                
                HStack (spacing: 5) {
                    ForEach((TabbedItems.allCases), id: \.self) { item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(5)
                .frame(height: 70)
                .background(Color("Background"))
                .cornerRadius(30)
                .shadow(radius: 5)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
