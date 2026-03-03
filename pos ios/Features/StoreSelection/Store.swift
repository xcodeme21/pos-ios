import Foundation

struct LoginResponse: Codable {
    let appName: String?
    let build: String?
    let data: LoginData?
    let message: String?
    let version: String?
}

struct LoginData: Codable {
    let username: String?
    let token: String?
    let expired: Int?
    let user_id: String?
}

struct BusinessUnitResponse: Codable {
    let appName: String?
    let build: String?
    let data: BusinessUnitData?
    let message: String?
    let version: String?
}

struct BusinessUnitData: Codable {
    let count: Int?
    let businessUnits: [BusinessUnit]?
}

struct BusinessUnit: Codable, Identifiable, Hashable {
    let companyCode: String
    let isOfflineSite: String
    let siteCode: String
    let siteName: String
    
    var id: String {
        return siteCode
    }
    
    
    var storeName: String {
        return siteName
    }
    
    var storeAddress: String {
        return "Company: \(companyCode)"
    }
}

struct StoreDetailResponse: Codable {
    let appName: String?
    let build: String?
    let data: StoreDetailData?
    let message: String?
    let version: String?
}

struct StoreDetailData: Codable {
    let storeInfo: StoreInfo?
    let settingsInfo: SettingsInfo?
}

struct StoreInfo: Codable {
    let code: String?
    let name: String?
    let isOpen: Bool?
    let channelCode: String?
    let companyCode: String?
    let posInboundProfile: String?
}

struct SettingsInfo: Codable {
    let settings: [StoreSetting]?
    let count: Int?
}

struct StoreSetting: Codable, Identifiable {
    let id: Int
    let name: String
    let group: String
    let type: String
    let value: String
    let description: String?
    let active: Bool
}
