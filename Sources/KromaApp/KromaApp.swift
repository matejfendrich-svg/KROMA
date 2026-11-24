import SwiftUI

@main
@MainActor
struct KromaApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup("Kroma") {
            MainWindowView(model: model)
                .frame(minWidth: 960, minHeight: 600)
        }
        .defaultSize(width: 1440, height: 900)
    }
}
