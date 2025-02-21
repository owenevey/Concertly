import SwiftUI

extension Font {
    static func system(size:CGFloat,type:FontSofiaProType = .Regular) -> Font{
        self.custom(type.rawValue, size: size)
        
    }
}
enum FontSofiaProType:String {
    case Thin = "Outfit-Thin"
    case ExtraLight = "Outfit-Thin_ExtraLight"
    case Light = "Outfit-Thin_Light"
    case Regular = "Outfit-Thin_Regular"
    case Medium = "Outfit-Thin_Medium"
    case SemiBold = "Outfit-Thin_SemiBold"
    case Bold = "Outfit-Thin_Bold"
    case ExtraBold = "Outfit-Thin_ExtraBold"
    case Black = "Outfit-Thin_Black"

}
