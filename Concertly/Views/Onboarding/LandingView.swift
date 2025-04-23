import SwiftUI

struct LandingView: View {
    
    @State private var activeCard: SuggestedArtist? = onboardingArtists.first
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @State private var initialAnimation = false
    @State private var titleProgress: CGFloat = 0
    @State private var scrollPhase: ScrollPhase = .idle
    
    var body: some View {
        NavigationStack {
            ZStack {
                AmbientBackground()
                    .animation(.easeInOut(duration: 1), value: activeCard )
                
                VStack(spacing: 40) {
                    InfiniteScrollView {
                        ForEach(onboardingArtists) {card in
                            CarouselCardView(card)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollPosition($scrollPosition)
                    .scrollClipDisabled()
                    .containerRelativeFrame(.vertical) { value, _ in
                        value * 0.45
                    }
                    .onScrollPhaseChange({ oldPhase, newPhase in
                        scrollPhase = newPhase
                    })
                    .onScrollGeometryChange(for: CGFloat.self) {
                        $0.contentOffset.x + $0.contentInsets.leading
                    } action: { oldValue, newValue in
                        currentScrollOffset = newValue
                        
                        if scrollPhase != .decelerating || scrollPhase != .animating {
                            let activeIndex = Int((currentScrollOffset / 220).rounded()) % onboardingArtists.count
                            activeCard = onboardingArtists[activeIndex]
                        }
                    }
                    .visualEffect { [initialAnimation] content, proxy in
                        content
                            .offset(y: !initialAnimation ? -(proxy.size.height + 200) : 0)
                    }
                    
                    VStack(spacing: 5) {
                        Text("Concertly")
                            .font(.system(size: 40, type: .SemiBold))
                            .foregroundStyle(.accent)
                            .textRenderer(TitleTextRenderer(progress: titleProgress))
                            .padding(.bottom, 12)
                        
                        Text("Discover concerts from all over the world.\nFind affordable flights and hotels to get you there and back.")
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.white.secondary)
                            .multilineTextAlignment(.center)
                            .blurOpacityEffect(initialAnimation)
                            .blurOpacityEffect(initialAnimation)
                    }
                    
                    NavigationLink(destination: SignInView()) {
                        Text("Get Started")
                            .font(.system(size: 17, type: .SemiBold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.accentColor)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        timer.upstream.connect().cancel()
                    })
                    .blurOpacityEffect(initialAnimation)

                }
                .safeAreaPadding(15)
            }
            .onReceive(timer) { _ in
                currentScrollOffset += 0.35
                scrollPosition.scrollTo(x: currentScrollOffset)
            }
            .task {
                try? await Task.sleep(for: .seconds(0.35))
                
                withAnimation(.smooth(duration: 0.75, extraBounce: 0)) {
                    initialAnimation = true
                }
                
                withAnimation(.smooth(duration: 1.5, extraBounce: 0).delay(0.3)) {
                    titleProgress = 1
                }
            }
        }
    }
    
    @ViewBuilder
    private func AmbientBackground() -> some View {
        GeometryReader{
            let size = $0.size
            
            ZStack {
                ForEach(onboardingArtists) { artist in
                    if let image = artist.localImageName {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                            .frame(width: size.width, height: size.height)
                            .opacity(activeCard?.id == artist.id ? 1 : 0)
                    }
                }
                
                Rectangle()
                    .fill(.black.opacity(0.45))
                    .ignoresSafeArea()
            }
            .compositingGroup()
            .blur(radius: 90, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func CarouselCardView(_ card: SuggestedArtist) -> some View {
        GeometryReader {
            let size = $0.size
            
            if let image = card.localImageName {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
            }
            
        }
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
}

#Preview {
    LandingView()
}


extension View {
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}
