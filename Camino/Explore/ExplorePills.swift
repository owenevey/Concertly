import SwiftUI

struct ExplorePills: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach((PillCategory.allCases), id: \.self) { category in
                    NavigationLink{
                        Text(category.title)
                    }
                    label: {
                        CategoryPill(title: category.title)
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

struct CategoryPill: View {
    var title: String
    var body: some View {
        Text(title)
            .font(Font.custom("Barlow-SemiBold", size: 15))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                Capsule(style: .continuous)
                    .fill(.card)
                    .stroke(Color(UIColor.lightGray), style: StrokeStyle(lineWidth: 1))
                    .padding(1)
            )
    }
}


enum PillCategory: Int, CaseIterable {
    case places
    case concerts
    case soccer
    case football
    case basketball
    
    var title: String{
        switch self {
        case .places:
            return "🕌 Places"
        case .concerts:
            return "🎸 Concerts"
        case .soccer:
            return "⚽️ Soccer"
        case .football:
            return "🏈 Football"
        case .basketball:
            return "🏀 Basketball"
        }
    }
}
