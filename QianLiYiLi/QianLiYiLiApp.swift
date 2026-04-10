import SwiftUI

@main
struct QianLiYiLiApp: App {
    init() {
        // 預熱節氣與農曆資料
        _ = getSolarTermsForYear(Calendar(identifier: .gregorian).component(.year, from: Date()))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
