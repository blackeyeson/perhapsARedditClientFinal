//
//  LeftSideMenuConfigurator.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import Foundation

enum LeftSideMenuConfigurator {
    static func configure() -> LeftSideMenuViewController {
//        let apiManager = APIManager()
//        let worker = LeftSideMenuWorker(apiManager: apiManager)
//        let presenter = LeftSideMenuPresenter()
//        let interactor = LeftSideMenuInteractor(presenter: presenter, worker: worker)
//        let router = LeftSideMenuRouter(dataStore: interactor)
        let viewController = LeftSideMenuViewController(
//            interactor: interactor, router: router
        )
//        presenter.viewController = viewController
//        router.viewController = viewController
        
        return viewController
    }
}
