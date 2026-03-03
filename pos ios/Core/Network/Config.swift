import Foundation

enum AppConfig {
    static var appName: String {
        return FirebaseRemoteConfigManager.shared.appName
    }
    static var baseURL: String {
        return FirebaseRemoteConfigManager.shared.posServiceBaseUrl
    }
    static var erpURL: String {
        return FirebaseRemoteConfigManager.shared.erpiBaseUrl
    }
    static let source   = "b2c"
}

struct RequestConfig {
    var isAuth: Bool = false
    var includeDeviceId: Bool = true
    var includeBuCode: Bool = false
    var includeSource: Bool = true
    
    static let `default`    = RequestConfig()
    static let authenticated = RequestConfig(isAuth: true)
    static let withBuCode   = RequestConfig(isAuth: true, includeBuCode: true)
}
