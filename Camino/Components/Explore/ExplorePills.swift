import SwiftUI

struct ExplorePills: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach((PillGenre.allCases), id: \.self) { genre in
                    NavigationLink{
                        Text(genre.title)
                    }
                    label: {
                        GenrePill(genre: genre)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    ExplorePills()
}

struct GenrePill: View {
    var genre: PillGenre
    
    var body: some View {
        Text("\(genre.emoji)   \(genre.title)")
            .font(.system(size: 14, type: .Medium))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.foreground)
                    .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
                    .padding(1)
            )
    }
}


enum PillGenre: Int, CaseIterable {
    case pop
    case rock
    case country
    case hipHop
    case rAndB
    case rap
    case latin
    
    var title: String {
        switch self {
        case .pop:
            return "Pop"
        case .rock:
            return "Rock"
        case .country:
            return "Country"
        case .hipHop:
            return "Hip Hop"
        case .rAndB:
            return "R&B"
        case .latin:
            return "Latin"
        case .rap:
            return "Rap"
        }
    }
    
    var emoji: String {
            switch self {
            case .pop: return "🎤"
            case .rock: return "🎸"
            case .country: return "🤠"
            case .hipHop: return "🎧"
            case .rAndB: return "🎶"
            case .latin: return "💃"
            case .rap: return "🎙️"
            }
        }
}
