import SwiftUI

struct GenrePills: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach((MusicGenre.allCases), id: \.self) { genre in
                    NavigationLink{
                        GenreView(genre: genre)
                            .navigationBarHidden(true)
                    }
                    label: {
                        GenrePill(genre: genre)
                    }.buttonStyle(PlainButtonStyle())
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 15)
    }
}

#Preview {
    GenrePills()
}

struct GenrePill: View {
    var genre: MusicGenre
    
    var body: some View {
        Text("\(genre.emoji)  \(genre.title)")
            .font(.system(size: 15, type: .Medium))
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


enum MusicGenre: Int, CaseIterable {
    case pop
    case country
    case hipHop
    case rock
    case alternative
    case dance
    case rAndB
    
    var title: String {
        switch self {
        case .pop:
            return "Pop"
        case .country:
            return "Country"
        case .hipHop:
            return "Hip Hop"
        case .rock:
            return "Rock"
        case .alternative:
            return "Alternative"
        case .dance:
            return "Dance"
        case .rAndB:
            return "R&B"
        }
    }
    
    var apiLabel: String {
        switch self {
        case .pop:
            return "pop"
        case .country:
            return "country"
        case .hipHop:
            return "hipHop"
        case .rock:
            return "rock"
        case .alternative:
            return "alternative"
        case .dance:
            return "dance"
        case .rAndB:
            return "rAndB"
        }
    }
    
    var emoji: String {
            switch self {
            case .pop: return "🎉"
            case .country: return "🤠"
            case .hipHop: return "🎧"
            case .rock: return "🎸"
            case .alternative: return "🌿"
            case .dance: return "🎛️"
            case .rAndB: return "🎶"
            }
        }
}
