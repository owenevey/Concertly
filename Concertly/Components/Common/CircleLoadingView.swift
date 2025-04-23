import SwiftUI

struct CircleLoadingView: View {
    @State private var rotationAngle = 0.0
    let ringSize: CGFloat
    var useWhite: Bool = false

        var colors: [Color] {
            useWhite
                ? [Color.white, Color.white.opacity(0.3)]
                : [Color.accent, Color.accent.opacity(0.3)]
        }

    var body: some View {
        ZStack {
            Circle()
               .stroke(
                   AngularGradient(
                       gradient: Gradient(colors: colors),
                       center: .center,
                       startAngle: .degrees(0),
                       endAngle: .degrees(360)
                   ),
                   style: StrokeStyle(lineWidth: ringSize/5, lineCap: .round)
                   
               )
               .frame(width: ringSize, height: ringSize)

            Circle()
                .frame(width: ringSize/5, height: ringSize/5)
                .foregroundColor(useWhite ? .white : Color.accent)
                .offset(x: ringSize/2)

        }
        .rotationEffect(.degrees(rotationAngle))
        .onAppear {
            withAnimation(.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)) {
                    rotationAngle = 360.0
                }
        }
        .onDisappear{
            rotationAngle = 0.0
        }
    }
}

#Preview {
    CircleLoadingView(ringSize: 20, useWhite: true)
}
