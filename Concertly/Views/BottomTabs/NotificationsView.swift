import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = NotificationsViewModel()
    
    @State private var showHeaderBorder: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BackButton()
                    
                    Text("Notifications")
                        .font(.system(size: 30, type: .SemiBold))
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
            }
            .background(Color.background)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.notifications.indices, id: \.self) { index in
                        NotificationRow(notification: viewModel.notifications[index])
                        if index < viewModel.notifications.count - 1 {
                            Divider()
                                .frame(height: 1)
                                .overlay(.gray2)
                                .padding(.horizontal, 15)
                        }
                    }
                }
                .padding(.bottom, 15)
            }
            .background(Color.background)
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                return geo.contentOffset.y
            } action: { oldValue, newValue in
                showHeaderBorder = newValue > 0
            }
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    NavigationStack {
        NotificationsView()
            .environmentObject(Router())
            .environmentObject(AnimationManager())
    }
}
