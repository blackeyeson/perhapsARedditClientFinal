//
//  RightSideMenuConfigurator.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import Foundation

enum RightSideMenuConfigurator {
    static func configure() -> RightSideMenuViewController {
////        let apiManager = APIManager()
////        let worker = RightSideMenuWorker(apiManager: apiManager)
//        let presenter = RightSideMenuPresenter()
//        let interactor = RightSideMenuInteractor(
////            presenter: presenter, worker: worker
//        )
//        let router = RightSideMenuRouter()
        let viewController = RightSideMenuViewController(
//            interactor: interactor, router: router
        )
//        presenter.viewController = viewController
//        router.viewController = viewController
//        
        return viewController
    }
}
