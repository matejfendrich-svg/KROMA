import SwiftUI

@main
@MainActor
struct KromaApp: App {
    var body: some Scene {
        WindowGroup("Kroma") {
            MainWindowView(model: AppModel.shared)
                .frame(minWidth: 960, minHeight: 600)
        }
        .defaultSize(width: 1440, height: 900)
    }
}
