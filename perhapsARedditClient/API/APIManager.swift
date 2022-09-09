//
//  APIManager.swift
//  CleanSwift_Academy
//
//  Created by Giorgi Bostoghanashvili on 28.08.22.
//

import Foundation
import Security

final class APIManager {
    func fetchData<T: Decodable>(urlString: String, decodingType: T.Type) async throws -> T {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else { throw ApiError.invalidUrl }
        
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else { throw ApiError.httpError }
        

        do {
           return try JSONDecoder().decode(decodingType.self, from: data)
        } catch {
            throw ApiError.decodingError
        }
    }
    
    func setUserDefaults<T>(value: T, Key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: Key)
    }
    
    func getUserDefaults<T>(Key: String, type: T.Type) async throws -> T? {
        let defaults = UserDefaults.standard
        let returnObject = defaults.object(forKey: Key) as? T
        return returnObject
    }
    
    func keyChainSave(username: String, passcode: String) -> Bool{
        let password = passcode.data(using: .utf8)!
        
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]
        
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User saved successfully in the keychain")
            return true
        } else {
            print("Something went wrong trying to save the user in the keychain")
            return false
        }
    }
    
    func KeyChainGetAccess(username: String, password: String) -> Bool {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?

        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let realPassword = String(data: passwordData, encoding: .utf8)
            {
                print(username)
                print(password)
                if realPassword == password { return true } else { return false }
            }
        } else {
            print("Something went wrong trying to find the user in the keychain"); return false
        }
        return false
    }
}
