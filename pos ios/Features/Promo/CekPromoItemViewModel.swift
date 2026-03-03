import Foundation
import Combine

class CekPromoItemViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var productInfo: ProductSearchItem?
    @Published var stock: Int = 0
    @Published var promoList: [PromoDetail] = []
    @Published var regularPrice: Int = 0
    
    let tiers: [(label: String, value: String)] = [
        ("Non-Member", "00"),
        ("Crew", "03"),
        ("Co-pilot", "04"),
        ("Pilot", "05"),
        ("Spacetronot", "06")
    ]
    
    func searchPromo(tierCode: String, sku: String) {
        guard !tierCode.isEmpty else {
            self.errorMessage = "Pilih tier dulu ya!"
            return
        }
        
        guard !sku.isEmpty else {
            self.errorMessage = "SKU jangan lupa diisi!"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        self.productInfo = nil
        self.stock = 0
        self.promoList = []
        
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        
        let searchEndpoint = "/pdp/search?keyword=\(sku)&business_code=\(buCode)&page=1&size=1"
        
        NetworkManager.shared.request(
            endpoint: searchEndpoint,
            customBaseURL: AppConfig.erpURL,
            config: .withBuCode
        ) { [weak self] (result: Result<ProductSearchResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let firstItem = response.data?.items?.first {
                        self?.productInfo = firstItem
                        self?.checkStockAndPromo(tierCode: tierCode, product: firstItem)
                    } else {
                        self?.isLoading = false
                        self?.errorMessage = "Barang nggak ketemu nih."
                    }
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Gagal cari barang: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func checkStockAndPromo(tierCode: String, product: ProductSearchItem) {
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        
        let stockEndpoint = "/pdp/stock?article_code=\(product.article_code)&business_code=\(buCode)&quantity=1"
        
        NetworkManager.shared.request(
            endpoint: stockEndpoint,
            customBaseURL: AppConfig.erpURL,
            config: .withBuCode
        ) { [weak self] (result: Result<ProductStockResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let quantity = response.data?.quantity ?? 0
                    if quantity <= 0 {
                        self?.isLoading = false
                        self?.errorMessage = "Yah, stoknya kosong."
                        return
                    }
                    self?.stock = quantity
                    self?.fetchPromo(tierCode: tierCode, product: product)
                    
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Gagal cek stok: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func fetchPromo(tierCode: String, product: ProductSearchItem) {
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        let encodedDesc = product.article_description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let typeCode = product.article_type_code ?? ""
        
        let promoEndpoint = "/pdp/promo?article_code=\(product.article_code)&article_description=\(encodedDesc)&article_type_code=\(typeCode)&member_class=\(tierCode)&business_code=\(buCode)&quantity=1"
        
        NetworkManager.shared.request(
            endpoint: promoEndpoint,
            customBaseURL: AppConfig.erpURL,
            config: .withBuCode
        ) { [weak self] (result: Result<ProductPromoResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.regularPrice = response.data?.reguler_sales_unit_price ?? 0
                    if let promos = response.data?.promo, !promos.isEmpty {
                        self?.promoList = promos
                    } else {
                        self?.promoList = []
                    }
                case .failure(let error):
                    self?.errorMessage = "Gagal ambil promo: \(error.localizedDescription)"
                }
            }
        }
    }
}
