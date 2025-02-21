import SwiftUI

struct PriceHistorySheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var insights: PriceInsights
    
    var color: Color {
        if insights.priceLevel == "high" {
            return Color.orange
        } else {
            return Color.green
        }
    }
    
    var smoothedPriceHistory: [[Int]] {
        let windowSize = 10
        return movingAverage(insights.priceHistory, windowSize: windowSize)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Price History")
                    .font(.system(size: 20, type: .SemiBold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 5) {
                    Text("Current Level:")
                        .font(.system(size: 17, type: .Regular))
                    
                    Text(insights.priceLevel.capitalized)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(color)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Typical Price Range: \(insights.typicalPriceRange[0].asDollarString) - \(insights.typicalPriceRange[1].asDollarString)")
                    .font(.system(size: 17, type: .Regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            PriceGraph(prices: smoothedPriceHistory)
                .padding(5)
                .padding(.bottom, 10)
            
            ConcertlyButton(label: "Done") {
                dismiss()
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(Color.background)
    }
}

func movingAverage(_ data: [[Int]], windowSize: Int) -> [[Int]] {
    var smoothedData: [[Int]] = []
    
    for i in 0..<data.count {
        let start = max(0, i - windowSize + 1)
        let end = min(data.count, i + 1)
        let window = data[start..<end]
        
        let avgPrice = window.map { $0[1] }.reduce(0, +) / window.count
        smoothedData.append([data[i][0], avgPrice])
    }
    
    return smoothedData
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
    
    PriceHistorySheet(insights: examplePriceInsights)
        .frame(height: 470)
}

