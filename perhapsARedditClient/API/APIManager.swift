//
//  APIManager.swift
//  CleanSwift_Academy
//
//  Created by Giorgi Bostoghanashvili on 28.08.22.
//

import Foundation
import Security
import UIKit
import AVFoundation

final class APIManager {
    
    //MARK: - internet
    
    func fetchData<T: Decodable>(urlString: String, decodingType: T.Type) async throws -> T {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else { throw ApiError.invalidUrl }
        
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else { throw ApiError.httpError }
        

        do {
           return try JSONDecoder().decode(decodingType.self, from: data)
        } catch {
            print("err/decoding")
            throw ApiError.decodingError
        }
    }
    
    //MARK: - userDefaults
    
    func setUserDefaults<T>(value: T, Key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: Key)
    }
    
    func getUserDefaults<T>(Key: String, type: T.Type) async throws -> T? {
        let defaults = UserDefaults.standard
        let returnObject = defaults.object(forKey: Key) as? T
        return returnObject
    }
    
    func getUser() async -> String {
        do {
            let username = try await getUserDefaults(Key: "username", type: String?.self) ?? "Guest"
            return username ?? "Guest"
        } catch {
            print("err/getUser")
            return "Guest"
        }
    }
    
    func addToHiddenPosts(reset: Bool, postId: String) {}
    
    //MARK: - keychain
    
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
    
    //MARK: - media Loading
    
    func loadImageFrom(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString)
        else { return UIImage(named: "loadingError") }
        
        guard let data = try? Data(contentsOf: url)
        else { return UIImage(named: "loadingError") }
        
        guard let image = UIImage(data: data)
        else { return UIImage(named: "loadingError") }
        
        return image
    }
    
    func loadGifFrom(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString)
        else { return UIImage(named: "loadingError") }
        return UIImage.gifImageWithURL("\(url)") ?? UIImage(named: "loadingError")
    }
    
    //MARK: - Loading media dimentions

    func imageDimenssions(url: String) -> [CGFloat] {
        if let imageSource = CGImageSourceCreateWithURL(URL(string: url)! as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
                return [pixelWidth, pixelHeight]
            }
        }
        return [200, 200]
    }
    
    func getVideoResolution(url: String) -> [CGFloat] {
        guard let track = AVURLAsset(url: URL(string: url)!).tracks(withMediaType: AVMediaType.video).first else { return [200, 200] }
        let size = track.naturalSize.applying(track.preferredTransform)
        return [abs(size.width), abs(size.height)]
    }
}
