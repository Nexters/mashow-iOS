import UIKit
import TipKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        guard
            let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String,
            let gptKey = Bundle.main.object(forInfoDictionaryKey: "GPT_KEY") as? String
        else {
            fatalError("XCConfig을 잘못 넣으셨군요...")
        }
        
        // 별점 요청 로직
        let appLaunchManager = AppLaunchManager()
        appLaunchManager.incrementLaunchCountAndRequestReviewIfNeeded()
        
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        return true
    }
}
