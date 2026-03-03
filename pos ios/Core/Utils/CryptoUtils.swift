import Foundation
import CommonCrypto

struct CryptoUtils {
    static func encryptPassword(_ text: String) -> String? {
        let keyString = "e9738b21b981a6f3"
        
        guard let data = text.data(using: .utf8),
              let keyData = keyString.data(using: .utf8) else { return nil }

        let keyLength = kCCKeySizeAES128
        let dataLength = data.count
        
        let cryptLength = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        
        var numBytesEncrypted: size_t = 0
        
        let iv = Data(count: kCCBlockSizeAES128) 
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    keyData.withUnsafeBytes { keyBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, keyLength,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress, dataLength,
                                cryptBytes.baseAddress, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            return cryptData.map { String(format: "%02x", $0) }.joined()
        }
        
        return nil
    }
}
