import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var nearbyViewModel: NearbyViewModel
    
    @AppStorage(AppStorageKeys.email.rawValue) private var email: String = ""
    @AppStorage(AppStorageKeys.homeAirport.rawValue) private var homeAirport: String = ""
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity: String = ""
    @AppStorage(AppStorageKeys.theme.rawValue) private var theme: String = "Default"
    @AppStorage(AppStorageKeys.concertReminders.rawValue) private var concertReminders: Int = concertRemindersEnum.dayBefore.rawValue
    @AppStorage(AppStorageKeys.newTourDates.rawValue) private var newTourDateNotifications: Bool = true
    
    @State private var isSearchBarVisible: Bool = true
    
    @State var showTourDateError = false
    
    @EnvironmentObject var router: Router
    
    @AppStorage(AppStorageKeys.authStatus.rawValue) private var authStatus: AuthStatus = .guest
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
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.gray2)
                                    .padding(.horizontal, 15)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .frame(width: 22)
                                    Text("New Tour Date Announcements")
                                        .font(.system(size: 17, type: .Regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    if authStatus == AuthStatus.registered {
                                        Menu {
                                            Button("On") {
                                                if !newTourDateNotifications {
                                                    newTourDateNotifications = true
                                                    Task {
                                                        let isSuccess = await NotificationManager.shared.updateNewTourDateNotifications()
                                                        showTourDateError = !isSuccess
                                                    }
                                                }
                                            }
                                            Button("Off") {
                                                if newTourDateNotifications {
                                                    newTourDateNotifications = false
                                                    Task {
                                                        let isSuccess = await NotificationManager.shared.updateNewTourDateNotifications()
                                                        showTourDateError = !isSuccess
                                                    }
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
                                    } else {
                                        Text("Login to enable")
                                            .font(.system(size: 17, type: .Regular))
                                    }
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
                        
                        if authStatus == .registered {
                            VStack {
                                Text("Account")
                                    .font(.system(size: 20, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 0) {
                                    
                                    Text(email)
                                        .font(.system(size: 17, type: .Medium))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 15)
                                        .contentShape(Rectangle())
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(.gray2)
                                        .padding(.horizontal, 15)
                                    
                                    Menu {
                                        Button("Confirm Sign Out") {
                                            AuthenticationManager.shared.signOut(completion: { _ in
                                                authStatus = .loggedOut
                                                router.reset()
                                            })
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                                .frame(width: 22)
                                            Text("Sign Out")
                                                .font(.system(size: 17, type: .Regular))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
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
                                    
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(.gray2)
                                        .padding(.horizontal, 15)
                                    
                                    NavigationLink(value: Routes.deleteAccount.rawValue) {
                                        HStack {
                                            Image(systemName: "trash.fill")
                                                .frame(width: 22)
                                            Text("Delete Account")
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
                        } else {
                            VStack {
                                Text("Account")
                                    .font(.system(size: 20, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 0) {
                                    
                                    ProfileRow(imageName: "person.circle.fill", name: Routes.login.rawValue, displayName: "Login", selection: "")
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(.gray2)
                                        .padding(.horizontal, 15)
                                    
                                    ProfileRow(imageName: "person.crop.circle.fill.badge.plus", name: Routes.register.rawValue, displayName: "Register", selection: "")
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray1)
                                        .frame(maxWidth: .infinity)
                                )
                            }
                        }
                        
                        Spacer()
                    }
                    .padding([.horizontal, .bottom], 15)
                    
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
                
                VStack {
                    Spacer()
                    SnackbarView(show: $showTourDateError, message: "Sorry, an error occurred. Please try again.")
                        .opacity(showTourDateError ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: showTourDateError)
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
