import SwiftUI

struct ShimmerView: View {
    
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endpoint: UnitPoint = .init(x: 0, y: -0.2)
    
    private var gradientColors = [Color.gray.opacity(0.2), Color.white.opacity(0.2), Color.gray.opacity(0.2)]
    
    var body: some View {
        VStack {
            LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endpoint)
        }
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                        startPoint = .init(x: 1, y: 1)
                        endpoint = .init(x: 2.2, y: 2.2)
                    }
                }
            }
    }
}

#Preview {
    FallbackConcertCard()
}
