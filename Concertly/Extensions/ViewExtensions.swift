import Foundation
import SwiftUI


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func readHeight() -> some View {
        self.modifier(ReadHeightModifier())
    }
    
    func disableSwipeBack(_ isDisabled: Bool) -> some View {
        self.background(DisableSwipeBack(isDisabled: isDisabled))
    }
    
    func snackbar(show: Binding<Bool>, bgColor: Color, txtColor: Color, icon: String?, iconColor: Color, message: String) -> some View {
        self.modifier(SnackbarModifier(show: show, bgColor: bgColor, txtColor: txtColor, icon: icon, iconColor: iconColor, message: message))
    }
}

struct SnackbarModifier: ViewModifier {
    @Binding var show: Bool
    var bgColor: Color
    var txtColor: Color
    var icon: String?
    var iconColor: Color
    var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView(show: $show, bgColor: bgColor, txtColor: txtColor, message: message)
        }
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


struct BottomSheetHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct ReadHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: BottomSheetHeightPreferenceKey.self,
                                   value: geometry.size.height)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}




struct DisableSwipeBack: UIViewControllerRepresentable {
    let isDisabled: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = !isDisabled
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = !isDisabled
        }
    }
}
