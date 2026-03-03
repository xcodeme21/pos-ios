import Foundation

struct SalesPersonResponse: Codable {
    let outError: Int?
    let outMessage: String?
    let outData: [SalesPerson]?
}

struct SalesPerson: Codable, Identifiable, Hashable {
    let salesPersonId: String
    let salesPersonFirstName: String
    let salesPersonLastName: String?
    
    var id: String {
        return salesPersonId
    }
    
    var fullName: String {
        let last = salesPersonLastName ?? ""
        return (salesPersonFirstName + " " + last).trimmingCharacters(in: .whitespaces)
    }
}
