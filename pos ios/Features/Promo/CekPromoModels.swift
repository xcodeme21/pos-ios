import Foundation

struct ProductSearchResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: ProductSearchData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct ProductSearchData: Decodable {
    let items: [ProductSearchItem]?
}

struct ProductSearchItem: Decodable {
    let article_code: String
    let article_description: String
    let article_type_code: String?
}

struct ProductStockResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: ProductStockData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct ProductStockData: Decodable {
    let article_id: String?
    let quantity: Int?
    let source_id: String?
}

struct ProductPromoResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: ProductPromoData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct ProductPromoData: Decodable {
    let reguler_sales_unit_price: Int?
    let promo: [PromoDetail]?
}

struct PromoDetail: Decodable, Identifiable {
    var id: String { promotion_id ?? UUID().uuidString }
    let promotion_id: String?
    let promotion_description: String?
    let article_code: String?
    let article_description: String?
    let promo_list: [PromoListItem]?
}

struct PromoListItem: Decodable, Identifiable {
    var id: String { promotion_id ?? UUID().uuidString }
    let promotion_id: String?
    let promotion_description: String?
    let bonus_buy_description: String?
    let article_code: String?
    let article_description: String?
    let additional_item: [PromoGroupItem]?
    let requirement_item: [PromoGroupItem]?
}

struct PromoGroupItem: Decodable {
    let additional_item: [PromoArticleItem]?
    let requirement_item: [PromoArticleItem]?
}

struct PromoArticleItem: Decodable {
    let article_code: String?
    let article_description: String?
}


struct PaymentMethodsResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: PaymentMethodsData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct PaymentMethodsData: Decodable {
    let payment_list: [PaymentMethodItem]?
}

struct PaymentMethodItem: Decodable, Identifiable {
    var id: String { payment_method_code ?? UUID().uuidString }
    let payment_method_code: String?
    let payment_method_name: String?
}


struct PaymentIssuerResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: [PaymentIssuerBank]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct PaymentIssuerBank: Decodable, Identifiable {
    var id: String { bank_code ?? UUID().uuidString }
    let bank_code: String?
    let bank_name: String?
    let payment_issuer_code: String?
    let payment_issuer_name: String?
    let payment_issuer_parent_code: String?
    let payment_issuer_parent_name: String?
    let issuers: [PaymentIssuerItem]?
}

struct PaymentIssuerItem: Decodable, Identifiable {
    var id: String { payment_issuer_code ?? UUID().uuidString }
    let payment_issuer_code: String?
    let payment_issuer_name: String?
    let payment_issuer_parent_code: String?
    let payment_issuer_parent_name: String?
}


struct ValidateCashbackResponse: Decodable {
    let statusCode: Int?
    let message: String?
    let data: CashbackPromoData?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case data
    }
}

struct CashbackPromoData: Decodable {
    let promotion_details: [CashbackPromotionDetail]?
}

struct CashbackPromotionDetail: Decodable, Identifiable {
    var id: String { promotion_id ?? UUID().uuidString }
    let promotion_id: String?
    let promotion_name: String?
    let type: String?
    let amount: Int?
}
