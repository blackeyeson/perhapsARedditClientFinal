//
//  LoginConfigurator.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import Foundation

enum LoginConfigurator {
    static func configure() -> LoginViewController {
        let apiManager = APIManager()
        let worker = LoginWorker(apiManager: apiManager)
//        let presenter = LoginPresenter()
        let interactor = LoginInteractor(worker: worker)
        let router = LoginRouter()
        let viewController = LoginViewController(
//    interactor: interactor, router: router
        )
//        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
