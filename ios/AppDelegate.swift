import UIKit
import AMapFoundationKit
import MAMapKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ========== 高德地图 SDK 配置 ==========
        // 必须在其他高德 SDK 功能使用之前配置
        
        // 0. 首先，配置隐私政策 UserDefaults（最关键！）
        configureAMapPrivacy()
        
        // 1. 设置 API Key（必需）
        AMapServices.shared().apiKey = "5c6cd2f4878b135fdf0141b103d45879"
        
        // 2. 启用 HTTPS
        AMapServices.shared().enableHTTPS = true
        
        let privacyShowStatus: AMapPrivacyShowStatus = .didShow  // 或 .notDetermined
        MAMapView.updatePrivacyShow(privacyShowStatus, privacyInfo: .didContain)

        // 检查隐私同意状态
        let privacyAgreeStatus: AMapPrivacyAgreeStatus = .didAgree  // 或 .notDetermined
        MAMapView.updatePrivacyAgree(privacyAgreeStatus)
        
        #if DEBUG
        print("✅ AMap SDK initialization completed")
        print("✅ Privacy: \(UserDefaults.standard.bool(forKey: "com.amap.privacy.shown"))")
        #endif
        
        return true
    }
    
    /// 配置高德地图隐私政策
    private func configureAMapPrivacy() {
        let userDefaults = UserDefaults.standard
        
        // 标记隐私合规已处理
        userDefaults.set(true, forKey: "com.amap.privacy.shown")
        
        // 标记用户已同意
        userDefaults.set(true, forKey: "com.amap.api.privacy.agree")
        
        // 标记 SDK 已处理隐私
        userDefaults.set(true, forKey: "com.amap.privacy.agree")
        
        // 同步确保数据被立即写入
        userDefaults.synchronize()
    }
}
