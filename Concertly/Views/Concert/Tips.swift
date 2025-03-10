import Foundation
import TipKit


struct SaveConcertTip: Tip {
    static let saveConcertEvent = Event(id: "saveConcert")
    static let visitConcertEvent = Event(id: "visitConcert")
    
    var title: Text {
        Text("Save Concert")
            .font(.system(size: 20, type: .SemiBold))
    }
    
    var message: Text? {
        Text("Tap here to save a concert to the Saved tab")
            .font(.system(size: 17, type: .Regular))
    }
    
    var rules: [Rule] {
        #Rule(Self.saveConcertEvent) { event in
            event.donations.count == 0
        }
        
        #Rule(Self.visitConcertEvent) { event in
            event.donations.count > 2
        }
    }
}


struct FollowArtistTip: Tip {
    static let followArtistEvent = Event(id: "followArtist")
    static let visitArtistEvent = Event(id: "visitArtist")
    
    var title: Text {
        Text("Follow Artist")
            .font(.system(size: 20, type: .SemiBold))
    }
    
    var message: Text? {
        Text("Tap here to follow an artist")
            .font(.system(size: 17, type: .Regular))
    }
    
    var rules: [Rule] {
        #Rule(Self.followArtistEvent) { event in
            event.donations.count == 0
        }
        
        #Rule(Self.visitArtistEvent) { event in
            event.donations.count > 2
        }
    }
}
