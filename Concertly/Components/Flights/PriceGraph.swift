import SwiftUI
import Charts

struct PriceGraph: View {
    struct PriceData: Identifiable {
        let id = UUID()
        let date: TimeInterval
        var price: Int
    }
    
    @State private var prices: [PriceData]
    
    init(prices: [[Int]]) {
        let rawData = prices.map { PriceData(date: TimeInterval($0[0]), price: $0[1]) }
                
                let downsampledData = rawData.enumerated().reduce(into: [PriceData]()) { result, entry in
                    let (index, item) = entry
                    if index % 3 == 0 { // Take every 3rd item
                        let chunk = rawData[index..<min(index + 3, rawData.count)]
                        let avgPrice = chunk.map(\.price).reduce(0, +) / chunk.count
                        result.append(PriceData(date: item.date, price: avgPrice))
                    }
                }
                
                self._prices = State(initialValue: downsampledData)
    }
    
    var maxPrice: Double {
        prices.map(\.price).max().map(Double.init) ?? 0
    }
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor.opacity(0.5), Color.accentColor.opacity(0.1)])
      }
    
    var body: some View {
        Chart {
            ForEach(prices) { item in
                LineMark(
                    x: .value("Date", Date(timeIntervalSince1970: item.date)),
                    y: .value("Price", item.price)
                )
                .foregroundStyle(.accent.gradient)
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Date", Date(timeIntervalSince1970: item.date)),
                    y: .value("Price", item.price)
                )
                .foregroundStyle(areaBackground)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: 0...(maxPrice + 250))
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("$\(intValue)")
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let dateValue = value.as(Date.self) {
                        Text(dateValue, format: .dateTime.day().month())
                    }
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    let prices = [
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
    
    PriceGraph(prices: prices)
        .padding()
}
