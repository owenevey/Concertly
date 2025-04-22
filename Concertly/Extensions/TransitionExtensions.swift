import Foundation
import SwiftUI

extension AnyTransition {
    static var slideInFromRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
    
    static var slideAndOpacity: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .opacity
        )
    }
}
