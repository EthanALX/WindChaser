import SwiftUI

@main
struct RunningOSApp: App {
    // 注册 AppDelegate 以配置高德地图
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
