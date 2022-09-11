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
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "GreetViewController") as! GreetViewController

        
//        let navigationController = UINavigationController(rootViewController: vc)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
