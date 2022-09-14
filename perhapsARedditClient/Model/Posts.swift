//
//  Country.swift
//  CleanSwift_Academy
//
//  Created by Giorgi Bostoghanashvili on 28.08.22.
//

import Foundation
import UIKit

//MARK: - subreddit page

struct RedditPosts: Decodable {
    
    var data: ListingData
    
    struct ListingData: Decodable {
        
        var children: [PostData]
        
        struct PostData: Decodable {
            let data: Post
        }
    }
}

struct Post: Decodable {
    let title: String
    let subreddit: String
    let subreddit_name_prefixed: String
    let ups: Int
    let domain: String
    let score: Int
    let is_created_from_ads_ui: Bool
    let thumbnail: URL?
    let url_overridden_by_dest: URL?
    let url: URL?
    let permalink: String
    let author: String
    let created_utc: Double
    let id: String
}

struct PostForTable {
    let postTitle: String
    let id: String
    let voteCount: String
    let picture: URL?
    let subredditIcon: URL?
    let thumbnail: URL?
    let subreddit: String
    let domain: String
    let oPUsername: String
    let timePassed: String
    let iconUrlString: String
}

//MARK: - about page

struct About: Decodable {
    let data: Stuff
    struct Stuff: Decodable {
        let icon_img: String
        let community_icon: String
    }
}

//MARK: - subreddits page

struct subredditsPage: Decodable {
    let data: Stuff
    struct Stuff: Decodable {
        let children: [Subs]
        struct Subs: Decodable {
            let data: SubPage
            struct SubPage: Decodable {
                let display_name: String
            }
        }
    }
}

//MARK: - general protocol

protocol configable: UIViewController {
    func config()
}


