//
//  LeftSideMenuWorker.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LeftSideMenuWorkerLogic {
    func setSub(subreddit: String)
    func setPeriod(timePeriod: String)
    func getPeriod() async -> Int
    func getSubreddits(request: LeftSideMenu.getSubs.Request) async -> LeftSideMenu.getSubs.Response
}

final class LeftSideMenuWorker: LeftSideMenuWorkerLogic {
    // MARK: - Fields
    
    private var api: APIManager
    
    init(apiManager: APIManager) {
        self.api = apiManager
    }
    
    // MARK: - Methods
    
    func setSub(subreddit: String) {
        api.setUserDefaults(value: subreddit, Key: "subreddit")
    }
    func setPeriod(timePeriod: String) {
        api.setUserDefaults(value: timePeriod, Key: "timePeriod")
    }
    func getPeriod() async -> Int {
        do {
            let period = try await api.getUserDefaults(Key: "timePeriod", type: String.self) ?? ""
            switch period { // converting string to mode Int
            case "day":
                return 0
            case "week":
                return 1
            case "month":
                return 2
            case "year":
                return 3
            case "all":
                return 4
            default:
                return 0
            }
        } catch { return 0 }
    }
    
    func getSubreddits(request: LeftSideMenu.getSubs.Request) async -> LeftSideMenu.getSubs.Response {
        let urlString = "https://www.reddit.com/subreddits.json"
        
        var response = LeftSideMenu.getSubs.Response(subreddits: [subredditsPage.Stuff.Subs]())
        
        do {
            response.subreddits = try await api.fetchData(urlString: urlString, decodingType: subredditsPage.self).data.children
        } catch {  }
        
        return response
    }
}
