//
//  MainScreenConfigurator.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import Foundation

enum MainScreenConfigurator {
    static func configure(username: String) -> MainScreenViewController {
        let apiManager = APIManager()
        let worker = MainScreenWorker(apiManager: apiManager)
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter, worker: worker)
        let router = MainScreenRouter(username: username)
        let viewController = MainScreenViewController(
//            interactor: interactor, router: router
        )
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
