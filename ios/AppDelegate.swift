import UIKit
import AMapFoundationKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // TODO: 替换为你的高德地图 API Key
        // 申请地址: https://console.amap.com/dev/key/app
        // 临时使用空字符串，地图可能无法显示，但不会崩溃
        AMapServices.shared().apiKey = "5c6cd2f4878b135fdf0141b103d45879"

        // 启用高德地图日志（调试用）
        #if DEBUG
        AMapServices.shared().enableHTTPS = true
        #endif

        return true
    }
}
