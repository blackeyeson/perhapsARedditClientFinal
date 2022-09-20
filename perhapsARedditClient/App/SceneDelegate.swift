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
        
        // creating default viewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: configable = mainStoryboard.instantiateViewController(withIdentifier: "GreetViewController") as! configable
        
        // checking if user is logged in
        let defaults = UserDefaults.standard
        let rawUsername = defaults.object(forKey: "username") as? String?
        let username: String = (rawUsername ?? "errorDingusGestimusPrimus") ?? "errorDingusGestimusPrimus"
        
        if username != "errorDingusGestimusPrimus" { //if logged in changing VC
            vc = mainStoryboard.instantiateViewController(identifier: "MainScreenViewController") as! configable
        } else { }
        
        vc.config() // configuring VC
        
        // setting default VC
        window = UIWindow(windowScene: scene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
