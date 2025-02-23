import Foundation
import SwiftUI

struct LandingCard: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
}

let cards: [LandingCard] = [
    .init(image: "aliciaKeys"),
    .init(image: "chrisStapleton"),
    .init(image: "oliviaRodrigo"),
    .init(image: "zachBryan"),
    .init(image: "kehlani"),
    .init(image: "noahKahan"),
    .init(image: "sza")
]
