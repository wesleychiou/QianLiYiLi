import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "sun.max.fill")
                }
                .tag(0)

            MonthCalendarView()
                .tabItem {
                    Label("月曆", systemImage: "calendar")
                }
                .tag(1)

            SolarTermsView()
                .tabItem {
                    Label("節氣", systemImage: "leaf.fill")
                }
                .tag(2)

            AuspiciousDateView()
                .tabItem {
                    Label("擇日", systemImage: "star.fill")
                }
                .tag(3)

            ShichenView()
                .tabItem {
                    Label("時辰", systemImage: "clock.fill")
                }
                .tag(4)
        }
        .tint(Color(hex: "#C9A84C"))
        .onAppear {
            configureTabBar()
            configureNavBar()
        }
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#0F1520"))
        appearance.shadowColor = UIColor(Color(hex: "#C9A84C").opacity(0.3))

        let normal = UITabBarItemAppearance()
        normal.normal.iconColor = UIColor(Color(hex: "#555570"))
        normal.normal.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#555570"))]
        normal.selected.iconColor = UIColor(Color(hex: "#C9A84C"))
        normal.selected.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#C9A84C"))]
        appearance.stackedLayoutAppearance = normal
        appearance.inlineLayoutAppearance = normal
        appearance.compactInlineLayoutAppearance = normal

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#0F1520"))
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#C9A84C"))]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
