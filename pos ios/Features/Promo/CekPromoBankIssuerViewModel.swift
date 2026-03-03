import Foundation
import Combine

class CekPromoBankIssuerViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedTier: String = "00"
    @Published var selectedPaymentMethod: PaymentMethodItem?
    @Published var selectedBank: PaymentIssuerBank?
    @Published var selectedIssuer: PaymentIssuerItem?
    @Published var nominal: String = ""
    @Published var skuInput: String = ""
    
    @Published var paymentMethods: [PaymentMethodItem] = []
    @Published var bankOptions: [PaymentIssuerBank] = []
    @Published var issuerOptions: [PaymentIssuerItem] = []
    
    @Published var productInfo: ProductSearchItem?
    @Published var stock: Int = 0
    @Published var promoValidation: CashbackPromoData?
    
    let tiers: [(label: String, value: String)] = [
        ("Non-Member", "00"),
        ("Crew", "03"),
        ("Co-pilot", "04"),
        ("Pilot", "05"),
        ("Spacetronot", "06")
    ]
    
    init() {
        fetchPaymentMethods()
    }
    
    func fetchPaymentMethods() {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let endpoint = "/payment/get?cashierId=\(userId)"
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            config: .withBuCode
        ) { [weak self] (result: Result<PaymentMethodsResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.paymentMethods = response.data?.payment_list ?? []
                case .failure(let error):
                    print("Error fetching payment methods: \(error)")
                }
            }
        }
    }
    
    func handlePaymentMethodChange(_ method: PaymentMethodItem) {
        selectedPaymentMethod = method
        selectedBank = nil
        selectedIssuer = nil
        bankOptions = []
        issuerOptions = []
        
        guard let name = method.payment_method_name else { return }
        
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if name == "Debit Card" || name == "Credit Card" {
            let endpoint = "/payment/issuer/bin?paymentMethod=\(encodedName)&cashierId=\(userId)"
            NetworkManager.shared.request(
                endpoint: endpoint,
                config: .withBuCode
            ) { [weak self] (result: Result<PaymentIssuerResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.bankOptions = response.data ?? []
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func onBankSelected(_ bank: PaymentIssuerBank) {
        selectedBank = bank
        selectedIssuer = nil
        issuerOptions = bank.issuers ?? []
    }
    
    func searchPromo() {
        guard !skuInput.isEmpty else {
            errorMessage = "SKU belum diisi"
            return
        }
        guard !nominal.isEmpty, let _ = Int(nominal) else {
            errorMessage = "Nominal nggak valid"
            return
        }
        guard selectedIssuer != nil else {
            errorMessage = "Issuer belum dipilih"
            return
        }
        
        isLoading = true
        errorMessage = nil
        productInfo = nil
        stock = 0
        promoValidation = nil
        
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        let searchEndpoint = "/pdp/search?keyword=\(skuInput)&business_code=\(buCode)&page=1&size=1"
        
        NetworkManager.shared.request(
            endpoint: searchEndpoint,
            customBaseURL: AppConfig.erpURL,
            config: .withBuCode
        ) { [weak self] (result: Result<ProductSearchResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let item = response.data?.items?.first {
                        self?.productInfo = item
                        self?.checkStockAndValidateCashback(item: item)
                    } else {
                        self?.isLoading = false
                        self?.errorMessage = "Produk nggak ketemu"
                    }
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Error cari produk: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func checkStockAndValidateCashback(item: ProductSearchItem) {
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        let stockEndpoint = "/pdp/stock?article_code=\(item.article_code)&business_code=\(buCode)&quantity=1"
        
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
                        self?.errorMessage = "Stok kosong nih"
                        return
                    }
                    self?.stock = quantity
                    self?.validateCashback(articleCode: item.article_code)
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Error cek stok: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func validateCashback(articleCode: String) {
        let endpoint = "/cashback/validate"
        let intNominal = Int(nominal) ?? 0
        
        let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
        
        let requestBody: [String: Any] = [
            "business_unit": buCode,
            "channel_code": "posbe-b2c-ear",
            "member_type": selectedTier,
            "prepos_number": "POS",
            "total_amount": intNominal,
            "company_code": "",
            "items": [
                [
                    "article_code": articleCode,
                    "final_amount": intNominal,
                    "quantity": 1
                ]
            ],
            "payment": [
                "payment_issuer": selectedIssuer?.payment_issuer_code ?? "",
                "payment_amount": intNominal
            ]
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            self.isLoading = false
            self.errorMessage = "Gagal bikin request body"
            return
        }
        
        NetworkManager.shared.request(
            endpoint: endpoint,
            method: "POST",
            body: httpBody,
            config: .withBuCode
        ) { [weak self] (result: Result<ValidateCashbackResponse, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if let promoData = response.data {
                        self?.promoValidation = promoData
                    } else if let msg = response.message {
                        self?.errorMessage = msg
                    }
                case .failure(let error):
                    self?.errorMessage = "Gagal info cashback: \(error.localizedDescription)"
                }
            }
        }
    }
}
