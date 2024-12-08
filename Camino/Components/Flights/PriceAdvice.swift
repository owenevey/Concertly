import SwiftUI

struct PriceAdvice: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .foregroundStyle(Color.green)
            HStack(spacing: 5) {
                Text("Our advice:")
                    .font(.system(size: 18, type: .Medium))
                Text("Buy")
                    .font(.system(size: 18, type: .Medium))
                    .foregroundStyle(Color.green)
            }
            Spacer()
            Image(systemName: "info.circle")
        }
        .padding(20)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
        )
    }
}

#Preview {
    PriceAdvice()
}
