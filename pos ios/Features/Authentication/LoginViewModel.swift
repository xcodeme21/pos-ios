import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    @AppStorage("authToken") var authToken: String = ""
    @AppStorage("savedUsername") var savedUsername: String = ""
    @AppStorage("savedUserId") var savedUserId: String = ""
    
    var isValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func login() {
        guard isValid else {
            self.errorMessage = "Mohon isi username dan password."
            return
        }
        
        self.errorMessage = ""
        self.isLoading = true
        
        guard let encryptedPassword = CryptoUtils.encryptPassword(password) else {
            self.errorMessage = "Gagal mengenkripsi kata sandi."
            self.isLoading = false
            return
        }
        
        let body: [String: String] = [
            "username": username,
            "password": encryptedPassword
        ]
        
        guard let jsonData = try? JSONEncoder().encode(body) else {
            self.isLoading = false
            return
        }
        
        NetworkManager.shared.request(
            endpoint: "/login",
            method: "POST",
            body: jsonData,
            config: RequestConfig(isAuth: false, includeDeviceId: true, includeSource: false)
        ) { (result: Result<LoginResponse, Error>) in
            self.isLoading = false
            switch result {
            case .success(let response):
                if let token = response.data?.token {
                    self.authToken = token
                    self.savedUsername = self.username
                    self.savedUserId = response.data?.user_id ?? ""
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = response.message ?? "Terjadi kesalahan saat login."
                }
            case .failure(let error):
                self.errorMessage = "Gagal terhubung ke server: \(error.localizedDescription)"
            }
        }
    }
}
