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
    let selftext: String
    let title: String
    let subreddit: String
    let subreddit_name_prefixed: String
    let ups: Int
    let domain: String
    let score: Int
    let is_created_from_ads_ui: Bool
    let thumbnail: String?
    let url_overridden_by_dest: String?
    let url: String?
    let permalink: String
    let author: String
    let created_utc: Double
    let id: String
    let is_video: Bool
    let media: Media?
    struct Media: Decodable {
        
        let reddit_video: RVideo?
        struct RVideo: Decodable {
            
            let fallback_url: String
        }
    }
}

struct PostForTable {
    let postTitle: String
    let id: String
    let permalink: String
    let voteCount: String
    let picture: String?
    let subredditIcon: String?
    let thumbnail: String?
    let subreddit: String
    let domain: String
    let oPUsername: String
    let timePassed: String
    let iconUrlString: String
    let isVideo: Bool
    let isGif: Bool
    let VideoUrlString: String?
    let bodyText: String
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

//MARK: - comments page

struct CommentsPageComponent: Decodable {
    let data: FirstChild
    struct FirstChild: Decodable {
        
        let children: [Children]
        struct Children: Decodable {
            
            let data: SecondChild
            struct SecondChild: Decodable {
                
                let body: String?
                let ups: Int?
                let author: String?
            }
        }
    }
}

struct CommentForTable {
    let auther: String
    let ups: String
    let body: String
}

//MARK: - general protocol

protocol configable: UIViewController {
    func config()
}


