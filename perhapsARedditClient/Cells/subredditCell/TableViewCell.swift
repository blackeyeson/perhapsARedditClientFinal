//
//  TableViewCell.swift
//  perhapsARedditClient
//
//  Created by a on 14.09.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var subIcon: UIImageView!
    @IBOutlet var subName: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(subredditName: String) {
        subName.text = "r/\(subredditName)"
        Task { await getIcon(subreddit: subredditName) }
        }
    
    func configure(sub: String, icon: String?) {
        subName.text = "r/\(sub)"
        subIcon.layer.cornerRadius = 20
        let finalUrlString = icon ?? "https://www.reddit.com/favicon.ico"
        subIcon.load(urlString: finalUrlString, indicator: nil)
    }
    
    func getIcon(subreddit: String) async {
        let session = URLSession.shared
        let urlString = "https://www.reddit.com/r/\(subreddit)/about.json"
        var iconUrlString = "https://www.reddit.com/favicon.ico"
        
        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await session.data(from: url)
                let docodedData = try JSONDecoder().decode(About.self, from: data).data
                
                if docodedData.icon_img != "" {
                    iconUrlString = docodedData.icon_img
                } else { iconUrlString = docodedData.community_icon }
                
                func removeExtraUrlString(url: String, extensionString: String) -> String {
                    var string = url
                    if let dotRange = string.range(of: extensionString) {
                        string.removeSubrange(dotRange.lowerBound..<string.endIndex)
                        string += extensionString
                    }
                    return string
                }
                
                iconUrlString = removeExtraUrlString(url: iconUrlString, extensionString: ".jpg")
                iconUrlString = removeExtraUrlString(url: iconUrlString, extensionString: ".png")
                iconUrlString = removeExtraUrlString(url: iconUrlString, extensionString: ".ico")
            } catch { print("err/decoding"); return }
        }
        
        subIcon.layer.cornerRadius = 20
        subIcon.load(urlString: iconUrlString, indicator: nil)
    }
}
