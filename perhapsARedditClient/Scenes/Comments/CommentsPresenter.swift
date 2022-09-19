//
//  CommentsPresenter.swift
//  perhapsARedditClient
//
//  Created by a on 19.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CommentsPresentationLogic {
    func presentPosts(response: Comments.getComments.Response)
}

class CommentsPresenter: CommentsPresentationLogic {
    // MARK: - Clean Components
    
    weak var viewController: CommentsDisplayLogic?
}

// MARK: - PresentationLogic

extension CommentsPresenter {
    
    func presentPosts(response: Comments.getComments.Response) {
        var viewModel = [CommentForTable]()
        
        let data = response.commentsPageComponents[1].data.children
        
        data.forEach {
            viewModel += [CommentForTable(auther: "r/\($0.data.author ?? "deleted")", ups: "\($0.data.ups ?? 0)", body: $0.data.body ?? "[Removed]" )]
        }
        
        viewController?.displayComments(viewModel: Comments.getComments.ViewModel(commentForTable: viewModel))
    }
}