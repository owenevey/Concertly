import SwiftUI

struct PriceInsightsCard: View {
    
    var insights: PriceInsights
    @State private var showPriceHistorySheet = false
    
    @State var detentHeight: CGFloat = 400
    
    var advice: String {
        if insights.priceLevel == "high" {
            return "Wait"
        } else {
            return "Buy"
        }
    }
    
    var color: Color {
        if insights.priceLevel == "high" {
            return Color.orange
        } else {
            return Color.green
        }
    }
    
    var body: some View {
        Button {
            showPriceHistorySheet = true
        }
        label: {
            HStack(spacing: 10) {
                Image(systemName: advice == "Buy" ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
                    .foregroundStyle(color)
                    .fontWeight(.semibold)
                HStack(spacing: 5) {
                    Text("Our advice:")
                        .font(.system(size: 18, type: .Medium))
                    Text(advice)
                        .font(.system(size: 18, type: .Medium))
                        .foregroundStyle(color)
                }
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .fontWeight(.semibold)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
                    .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .sheet(isPresented: $showPriceHistorySheet) {
                PriceHistorySheet(insights: insights)
                    .readHeight()
                    .onPreferenceChange(BottomSheetHeightPreferenceKey.self) { height in
                        if let height {
                            self.detentHeight = height
                        }
                    }
                    .presentationDetents([.height(self.detentHeight)])
                    .background(Color.background)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let examplePriceInsights = PriceInsights(
        lowestPrice: 379,
        priceLevel: "high",
        typicalPriceRange: [145, 345],
        priceHistory: [
            [1727758800, 155],
            [1727845200, 152],
            [1727931600, 280],
            [1728018000, 280],
            [1728104400, 289],
            [1728190800, 289],
            [1728277200, 289],
            [1728363600, 209],
            [1728450000, 209],
            [1728536400, 201],
            [1728622800, 137],
            [1728709200, 137],
            [1728795600, 137],
            [1728882000, 137],
            [1728968400, 176],
            [1729054800, 173],
            [1729141200, 143],
            [1729227600, 143],
            [1729314000, 166],
            [1729400400, 250],
            [1729486800, 166],
            [1729573200, 166],
            [1729659600, 157],
            [1729746000, 157],
            [1729832400, 151],
            [1729918800, 151],
            [1730005200, 151],
            [1730091600, 151],
            [1730178000, 151],
            [1730264400, 151],
            [1730350800, 175],
            [1730437200, 213],
            [1730523600, 222],
            [1730610000, 213],
            [1730700000, 213],
            [1730786400, 216],
            [1730872800, 216],
            [1730959200, 216],
            [1731045600, 176],
            [1731132000, 176],
            [1731218400, 216],
            [1731304800, 216],
            [1731391200, 216],
            [1731477600, 298],
            [1731564000, 206],
            [1731650400, 206],
            [1731736800, 216],
            [1731823200, 216],
            [1731909600, 216],
            [1731996000, 245],
            [1732082400, 355],
            [1732168800, 350],
            [1732255200, 292],
            [1732341600, 292],
            [1732428000, 376],
            [1732514400, 352],
            [1732600800, 337],
            [1732687200, 397],
            [1732773600, 397],
            [1732860000, 354],
            [1732946400, 379]
        ]
    )
    
    NavigationStack {
        PriceInsightsCard(insights: examplePriceInsights)
            .padding()
    }
}

