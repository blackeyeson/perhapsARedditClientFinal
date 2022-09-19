//
//  LeftSideMenuPresenter.swift
//  perhapsARedditClient
//
//  Created by a on 14.09.22.
//

import UIKit

protocol LeftSideMenuPresentationLogic {
    func selectRow(response: Int)
    func presentSubs(viewModel: LeftSideMenu.getSubs.ViewModel)
}

class leftSideMenuPresenter: LeftSideMenuPresentationLogic {
    
    // MARK: - Clean Components
    
    weak var viewController: LeftSideMenuDisplayLogic?
}

// MARK: - PresentationLogic

extension leftSideMenuPresenter {
    func presentSubs(viewModel: LeftSideMenu.getSubs.ViewModel) {
        viewController?.displaySubs(viewModel: viewModel)
    }
    
    func selectRow(response: Int) {
        viewController?.selectRow(viewModel: LeftSideMenu.selectRow.ViewModel(row: response))
    }
}

