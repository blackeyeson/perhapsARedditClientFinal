//
//  SceneDelegate.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setupInitialViewController(with: scene)
    }
}

extension SceneDelegate {
    private func setupInitialViewController(with scene: UIWindowScene) {
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: configable = mainStoryboard.instantiateViewController(withIdentifier: "GreetViewController") as! configable
        
        let defaults = UserDefaults.standard
        let rawUsername = defaults.object(forKey: "username") as? String?
        let username: String = (rawUsername ?? "Guest") ?? "Guest"
        
        if username != "Guest" {
            vc = mainStoryboard.instantiateViewController(identifier: "MainScreenViewController") as! configable
        }
        
        vc.config()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
