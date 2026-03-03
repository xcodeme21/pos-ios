import Foundation
import Combine

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let stock: Int
    let imageUrl: String?
}

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    var subtotal: Double {
        return product.price * Double(quantity)
    }
}

class TransactionViewModel: ObservableObject {
    @Published var selectedSalesman: SalesPerson?
    @Published var selectedCustomer: Customer?
    
    @Published var cartItems: [CartItem] = []
    @Published var searchQuery: String = ""
    
    @Published var availableProducts: [Product] = [
        Product(id: "1", name: "Kopi Hitam", price: 15000, stock: 50, imageUrl: nil),
        Product(id: "2", name: "Es Teh Manis", price: 8000, stock: 100, imageUrl: nil),
        Product(id: "3", name: "Nasi Goreng Spesial", price: 35000, stock: 20, imageUrl: nil),
        Product(id: "4", name: "Mie Goreng Rasa Ayam", price: 30000, stock: 25, imageUrl: nil),
        Product(id: "5", name: "Ayam Penyet + Nasi", price: 40000, stock: 15, imageUrl: nil),
        Product(id: "6", name: "Kerupuk Udang", price: 5000, stock: 200, imageUrl: nil)
    ]
    
    @Published var salesmanList: [SalesPerson] = []
    
    func fetchSalesData(siteCode: String) {
        let endpoint = "/pos/salesman/\(siteCode)"
        NetworkManager.shared.request(endpoint: endpoint, customBaseURL: AppConfig.erpURL, config: .withBuCode) { [weak self] (result: Result<SalesPersonResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let data = response.outData {
                        self?.salesmanList = data
                    }
                case .failure(let err):
                    print("Gagal fetch sales: \(err.localizedDescription)")
                }
            }
        }
    }
    
    @Published var customerList: [Customer] = [
        Customer(id: "C1", name: "Retail Customer", phone: "-", membership: .reguler),
        Customer(id: "C2", name: "Toko Makmur", phone: "0812345678", membership: .vip)
    ]
    
    var filteredProducts: [Product] {
        if searchQuery.isEmpty {
            return availableProducts
        } else {
            return availableProducts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var totalCartItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + $1.subtotal }
    }
    
    
    func addToCart(product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if newQuantity > 0 {
                cartItems[index].quantity = newQuantity
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
        selectedCustomer = nil
        selectedSalesman = nil
    }
}

struct Customer: Identifiable, Hashable {
    let id: String
    let name: String
    let phone: String
    let membership: MembershipTier
    
    enum MembershipTier: String {
        case reguler = "Reguler"
        case vip = "VIP"
    }
}
