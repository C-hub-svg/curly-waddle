import SwiftUI

@main
struct WellPhoneApp: App {
    @StateObject private var store = WellPhoneStore()
    @StateObject private var appBlocking = AppBlockingStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(appBlocking)
                .tint(WellPhoneStyle.green)
                .preferredColorScheme(.light)
        }
    }
}
