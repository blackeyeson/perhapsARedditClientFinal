//
//  GreetConfigurator.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

import Foundation

enum GreetConfigurator {
    static func configure() -> GreetViewController {
        let router = GreetRouter()
        let viewController = GreetViewController(router: router)
        router.viewController = viewController
        
        return viewController
    }
}
