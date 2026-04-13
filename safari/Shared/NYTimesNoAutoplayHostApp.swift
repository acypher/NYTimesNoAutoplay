import SwiftUI

@main
struct NYTimesNoAutoplayHostApp: App {
    var body: some Scene {
        WindowGroup {
            Text(
                "NYTimesNoAutoplay runs in Safari. Turn it on under Safari → Settings → Extensions and allow nytimes.com."
            )
            .padding(24)
            .multilineTextAlignment(.center)
            #if os(macOS)
                .frame(minWidth: 360, minHeight: 160)
            #endif
        }
    }
}
