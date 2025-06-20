import SwiftUI
import GoogleMobileAds

struct BannerViewContainer: UIViewRepresentable {
    let adSize: AdSize
    let adUnitID: String

        init(_ adSize: AdSize, adUnitID: String) {
            self.adSize = adSize
            self.adUnitID = adUnitID
        }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let bannerView = context.coordinator.bannerView
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.bannerView.adSize = adSize
    }
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self, adUnitID: adUnitID)
    }
    // [END create_banner_view]
    
    // [START create_banner]
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        private(set) lazy var bannerView: BannerView = {
            let banner = BannerView(adSize: parent.adSize)
            
            banner.adUnitID = adUnitID
            banner.load(Request())

            banner.delegate = self

            return banner
        }()
        
        let parent: BannerViewContainer
        let adUnitID: String
        
        init(_ parent: BannerViewContainer, adUnitID: String) {
                    self.parent = parent
                    self.adUnitID = adUnitID
                }
                
//        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
//            print("DID RECEIVE AD.")
//        }
//        
//        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
//            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
//        }
    }
}

enum AdUnitIds: String {
    case exploreBanner = "ca-app-pub-9918703140508010/3624609722"
    case flightsBanner = "ca-app-pub-9918703140508010/2713286061"
    case hotelsBanner = "ca-app-pub-9918703140508010/9090158002"
    case nearbyBanner = "ca-app-pub-9918703140508010/7362977517"
}
