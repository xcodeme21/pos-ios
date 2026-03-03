import Foundation
import FirebaseRemoteConfig

class FirebaseRemoteConfigManager {
    static let shared = FirebaseRemoteConfigManager()
    
    private var remoteConfig: RemoteConfig
    
    var appName: String = ""
    var posServiceBaseUrl: String = ""
    var erpiBaseUrl: String = ""
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 3600
        #endif
        remoteConfig.configSettings = settings
        
        let defaults: [String: NSObject] = [
            "appName": "POS Era" as NSObject,
            "posServiceBaseUrl": "https://jeanne.eraspace.com/posbe-b2c-ear/api/v1" as NSObject, 
            "erpiBaseUrl": "https://erpi-pos.eraspace.com" as NSObject 
        ]
        remoteConfig.setDefaults(defaults)
        
        updateProperties()
    }
    
    func fetchRemoteConfig(completion: (() -> Void)? = nil) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self?.updateProperties()
            }
            completion?()
        }
    }
    
    private func updateProperties() {
        let appNameVal = remoteConfig.configValue(forKey: "appName").stringValue
        if !appNameVal.isEmpty {
            self.appName = appNameVal
        }
        
        let posBaseVal = remoteConfig.configValue(forKey: "posServiceBaseUrl").stringValue
        if !posBaseVal.isEmpty {
            self.posServiceBaseUrl = posBaseVal
        }
        
        let erpBaseVal = remoteConfig.configValue(forKey: "erpiBaseUrl").stringValue
        if !erpBaseVal.isEmpty {
            self.erpiBaseUrl = erpBaseVal
        }
    }
}
