import SwiftUI
import FirebaseAnalytics

struct GenrePills: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach((MusicGenre.allCases), id: \.self) { genre in
                    NavigationLink(value: genre) {
                        GenrePill(genre: genre)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                            AnalyticsParameterItemID: genre.apiLabel,
                            AnalyticsParameterItemName: genre.title,
                          AnalyticsParameterContentType: "cont",
                        ])
                    })
                }
            }
            .shadow(color: .black.opacity(0.2), radius: 5)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 15)
    }
}

#Preview {
    NavigationStack {
        GenrePills()
    }
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
            )
            .shadow(color: .clear, radius: 0)
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
