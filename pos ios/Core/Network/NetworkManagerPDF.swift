import Foundation

extension NetworkManager {
    
    
    func downloadPDF(
        endpoint: String,
        method: String = "POST",
        body: Data? = nil,
        config: RequestConfig = .default,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        guard let url = URL(string: AppConfig.baseURL + endpoint) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        
        request.setValue("application/pdf", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if config.includeSource { request.setValue(AppConfig.source, forHTTPHeaderField: "Source") }
        if config.includeDeviceId {
            let deviceId = UserDefaults.standard.string(forKey: "deviceId") ?? UUID().uuidString
            UserDefaults.standard.set(deviceId, forKey: "deviceId")
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
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let pdfData = data else {
                
                
                if let httpRes = response as? HTTPURLResponse {
                    print("Download API Error Status Code: \(httpRes.statusCode)")
                    if let errData = data, let errString = String(data: errData, encoding: .utf8) {
                        print("Error Response Body: \(errString)")
                    }
                }
                
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Download failed or Invalid Response", code: 0, userInfo: nil)))
                }
                return
            }
            
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            
            let safeEndpointName = endpoint.replacingOccurrences(of: "/", with: "_").trimmingCharacters(in: CharacterSet(charactersIn: "_"))
            let timestamp = String(Int(Date().timeIntervalSince1970))
            let destinationURL = documentsURL.appendingPathComponent("Report_\(safeEndpointName)_\(timestamp).pdf")
            
            do {
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                
                try pdfData.write(to: destinationURL, options: .atomic)
                
                DispatchQueue.main.async { completion(.success(destinationURL)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        
        task.resume()
    }
}
