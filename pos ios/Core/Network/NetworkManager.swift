import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        customBaseURL: String? = nil,
        method: String = "GET",
        body: Data? = nil,
        config: RequestConfig = .default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let baseToUse = customBaseURL ?? AppConfig.baseURL
        guard let url = URL(string: baseToUse + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if config.includeSource {
            request.setValue(AppConfig.source, forHTTPHeaderField: "Source")
        }
        
        if config.includeDeviceId {
            let deviceId = getOrCreateDeviceId()
            request.setValue(deviceId, forHTTPHeaderField: "device-id")
        }
        
        if config.isAuth {
            let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if config.includeBuCode {
            let buCode = UserDefaults.standard.string(forKey: "buCode") ?? ""
            request.setValue(buCode, forHTTPHeaderField: "Business-unit-code")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                }
                return
            }
            print("DEBUG: URL \(url)")
            print("DEBUG: Raw RESPONSE: \(String(data: data, encoding: .utf8) ?? "")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch {
                print("DEBUG: DEC ERROR: \(error)")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        task.resume()
    }
    
    
    
    private func getOrCreateDeviceId() -> String {
        if let existing = UserDefaults.standard.string(forKey: "deviceId") {
            return existing
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: "deviceId")
        return newId
    }
}
