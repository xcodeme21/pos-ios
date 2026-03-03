import SwiftUI
import Combine

class StoreSelectionViewModel: ObservableObject {
    @Published var businessUnits: [BusinessUnit] = []
    @Published var searchQuery: String = ""
    @Published var currentPage: Int = 1
    
    @AppStorage("authToken") var authToken: String = ""
    
    let itemsPerPage = 6
    
    init() {
        fetchStores()
    }
    
    var filteredStores: [BusinessUnit] {
        let allFiltered = searchQuery.isEmpty ? businessUnits : businessUnits.filter {
            $0.siteName.localizedCaseInsensitiveContains(searchQuery) ||
            $0.siteCode.localizedCaseInsensitiveContains(searchQuery) ||
            $0.companyCode.localizedCaseInsensitiveContains(searchQuery)
        }
        
        let startIndex = (currentPage - 1) * itemsPerPage
        var endIndex = startIndex + itemsPerPage
        
        if startIndex >= allFiltered.count { return [] }
        if endIndex > allFiltered.count { endIndex = allFiltered.count }
        
        return Array(allFiltered[startIndex..<endIndex])
    }
    
    var totalPages: Int {
        let count = searchQuery.isEmpty ? businessUnits.count : businessUnits.filter {
            $0.siteName.localizedCaseInsensitiveContains(searchQuery) ||
            $0.companyCode.localizedCaseInsensitiveContains(searchQuery)
        }.count
        return Int(ceil(Double(count) / Double(itemsPerPage)))
    }
    
    var hasNextPage: Bool { currentPage < totalPages }
    var hasPreviousPage: Bool { currentPage > 1 }
    
    func nextPage() { if hasNextPage { currentPage += 1 } }
    func previousPage() { if hasPreviousPage { currentPage -= 1 } }
    func resetPagination() { currentPage = 1 }
    
    func fetchStores() {
        guard !authToken.isEmpty else { return }
        
        
        NetworkManager.shared.request(
            endpoint: "/business-unit",
            method: "GET",
            config: RequestConfig.authenticated
        ) { (result: Result<BusinessUnitResponse, Error>) in
            switch result {
            case .success(let response):
                print("DEBUG: Fetched BusinessUnitResponse Message: \(response.message ?? "")")
                print("DEBUG: Units Count: \(response.data?.businessUnits?.count ?? 0)")
                if let units = response.data?.businessUnits {
                    DispatchQueue.main.async {
                        self.businessUnits = units.sorted { $0.siteName < $1.siteName }
                        self.resetPagination()
                    }
                }
            case .failure(let error):
                print("Error loading stores: \(error)")
            }
        }
    }
    
    func fetchStoreDetails(siteCode: String, completion: @escaping () -> Void) {
        
        NetworkManager.shared.request(
            endpoint: "/business-unit/\(siteCode)",
            method: "GET",
            config: RequestConfig.authenticated
        ) { (result: Result<StoreDetailResponse, Error>) in
            switch result {
            case .success(let response):
                if let settings = response.data?.settingsInfo?.settings {
                    ThemeManager.shared.parseSettings(settings)
                }
                DispatchQueue.main.async { completion() }
            case .failure(let error):
                print("Error loading store details: \(error)")
                DispatchQueue.main.async { completion() }
            }
        }
    }
}
