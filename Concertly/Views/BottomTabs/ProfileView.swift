import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var nearbyViewModel: NearbyViewModel
    
    @AppStorage(AppStorageKeys.email.rawValue) private var email: String = "owenevey@gmail.com"
    @AppStorage(AppStorageKeys.homeAirport.rawValue) private var homeAirport: String = "JFK"
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity: String = "New York, NY"
    @AppStorage(AppStorageKeys.theme.rawValue) private var theme: String = "Default"
    @AppStorage(AppStorageKeys.concertReminders.rawValue) private var concertReminders: Int = concertRemindersEnum.dayBefore.rawValue
    @AppStorage(AppStorageKeys.newTourDates.rawValue) private var newTourDateNotifications: Bool = true
    
    @State private var isSearchBarVisible: Bool = true
    
    @EnvironmentObject var router: Router
    
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false
    
    var concertRemindersSelection: String {
        switch concertReminders {
        case 1:
            return "Day Before"
        case 7:
            return "Week Before"
        default:
            return "Off"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Text("Profile")
                            .font(.system(size: 30, type: .Bold))
                            .foregroundStyle(.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                            .padding(.bottom, 10)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("Following")
                                    .font(.system(size: 20, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if profileViewModel.followingArtists.count > 2 {
                                    NavigationLink(value: profileViewModel.followingArtists) {
                                        HStack(spacing: 5) {
                                            Text("View all")
                                                .font(.system(size: 17, type: .Medium))
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 12))
                                                .fontWeight(.semibold)
                                                .padding(.top, 2)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    if profileViewModel.followingArtists.count > 0 {
                                        ForEach(profileViewModel.followingArtists) { artist in
                                            ArtistCard(artist: artist)
                                        }
                                        .shadow(color: .black.opacity(0.2), radius: 5)
                                    } else {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray2, lineWidth: 4)
                                            .frame(width: 200, height: 230)
                                            .overlay(
                                                VStack(spacing: 15) {
                                                    Image(systemName: "plus.circle")
                                                        .font(.system(size: 35, weight: .semibold))
                                                    Text("Follow artists to see them here")
                                                        .font(.system(size: 16, type: .Medium))
                                                        .multilineTextAlignment(.center)
                                                }
                                            )
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray2, lineWidth: 4)
                                            .frame(width: 200, height: 230)
                                        
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray2, lineWidth: 4)
                                            .frame(width: 200, height: 230)
                                    }
                                }
                                
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .safeAreaPadding(.horizontal, 15)
                            .padding(.horizontal, -15)
                        }
                        
                        VStack(spacing: 10) {
                            Text("Preferences")
                                .font(.system(size: 20, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 0) {
                                ProfileRow(imageName: "airplane.departure", name: AppStorageKeys.homeAirport.rawValue, displayName: "Home Airport", selection: homeAirport)
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.gray2)
                                    .padding(.horizontal, 15)
                                
                                ProfileRow(imageName: "building.2.fill", name: AppStorageKeys.homeCity.rawValue, displayName: "Home City", selection: homeCity)
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.gray2)
                                    .padding(.horizontal, 15)
                                
                                HStack {
                                    Image(systemName: "circle.lefthalf.filled")
                                        .frame(width: 22)
                                    Text("Theme")
                                        .font(.system(size: 17, type: .Regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Default") { theme = "Default" }
                                        Button("Light") { theme = "Light" }
                                        Button("Dark") { theme = "Dark" }
                                    } label: {
                                        Text(theme)
                                            .font(.system(size: 17, type: .Regular))
                                            .padding(.leading, 10)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .contentShape(Rectangle())
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray1)
                                    .frame(maxWidth: .infinity)
                            )
                        }
                        .padding(.bottom, 20)
                        
                        VStack(spacing: 10) {
                            Text("Notifications")
                                .font(.system(size: 20, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "bookmark.fill")
                                        .frame(width: 22)
                                    Text("Concert Reminders")
                                        .font(.system(size: 17, type: .Regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Day Before") {
                                            concertReminders = concertRemindersEnum.dayBefore.rawValue
                                            NotificationManager.shared.updateAllConcertReminders()
                                        }
                                        Button("Week Before") {
                                            concertReminders = concertRemindersEnum.weekBefore.rawValue
                                            NotificationManager.shared.updateAllConcertReminders()
                                        }
                                        Button("Off") {
                                            concertReminders = concertRemindersEnum.off.rawValue
                                            NotificationManager.shared.updateAllConcertReminders()
                                        }
                                    } label: {
                                        Text(concertRemindersSelection)
                                            .font(.system(size: 17, type: .Regular))
                                            .padding(.leading, 10)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .contentShape(Rectangle())
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .frame(width: 22)
                                    Text("New Tour Date Announcements")
                                        .font(.system(size: 17, type: .Regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("On") {
                                            newTourDateNotifications = true
                                            Task {
                                                await NotificationManager.shared.updateNewTourDateNotifications()
                                            }
                                        }
                                        Button("Off") {
                                            newTourDateNotifications = false
                                            Task {
                                                await NotificationManager.shared.updateNewTourDateNotifications()
                                            }
                                        }
                                    } label: {
                                        Text(newTourDateNotifications ? "On" : "Off")
                                            .font(.system(size: 17, type: .Regular))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .contentShape(Rectangle())
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray1)
                                    .frame(maxWidth: .infinity)
                            )
                        }
                        .padding(.bottom, 20)
                        
                        VStack {
                            Text("Account")
                                .font(.system(size: 20, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 0) {
                                
                                Text(email)
                                    .font(.system(size: 17, type: .Regular))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 15)
                                    .contentShape(Rectangle())
                                
                                NavigationLink(value: "name") {
                                    HStack {
                                        Image(systemName: "gear")
                                            .frame(width: 22)
                                        Text("Settings")
                                            .font(.system(size: 17, type: .Regular))
                                        
                                        Spacer()
  
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 15)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray1)
                                    .frame(maxWidth: .infinity)
                            )
                        }
                        
                        ConcertlyButton(label: "SignOut") {
                            AuthenticationService.shared.signOut { _ in
                                router.selectedTab = 0
                                isSignedIn = false
                                hasFinishedOnboarding = false
                                selectedNotificationPref = false
                            }
                        }
                        .padding(.vertical, 15)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue + geometry.safeAreaInsets.top > 20 {
                            isSearchBarVisible = false
                        } else {
                            isSearchBarVisible = true
                        }
                    }
                }
                
                ExploreHeader()
                    .opacity(isSearchBarVisible ? 0 : 1)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .onAppear {
            profileViewModel.getFollowingArtists()
        }
//        .onChange(of: homeCity) {
//            Task {
//                await nearbyViewModel.getNearbyConcerts()
//            }
//        }
    }
    
    struct ProfileRow: View {
        let imageName: String
        let name: String
        let displayName: String
        let selection: String
        
        
        var body: some View {
            NavigationLink(value: name) {
                HStack {
                    Image(systemName: imageName)
                        .frame(width: 22)
                    Text(displayName)
                        .font(.system(size: 17, type: .Regular))
                    
                    Spacer()
                    
                    Text(selection)
                        .font(.system(size: 17, type: .Regular))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(profileViewModel: ProfileViewModel(), nearbyViewModel: NearbyViewModel())
            .environmentObject(Router())
            .environmentObject(AnimationManager())
    }
}
