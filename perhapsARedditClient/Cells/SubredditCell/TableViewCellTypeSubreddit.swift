//
//  TableViewCell.swift
//  perhapsARedditClient
//
//  Created by a on 14.09.22.
//

import UIKit

class TableViewCellTypeSubreddit: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Views
    @IBOutlet var subIcon: UIImageView!
    @IBOutlet var subName: UILabel!
    
    // MARK: - Life cycle
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - configuration
    func configure(sub: String, icon: String?) {
        subName.text = "r/\(sub)"
        subIcon.layer.cornerRadius = 20
        let finalUrlString = icon ?? "https://www.reddit.com/favicon.ico"
        subIcon.layer.cornerRadius = subIcon.bounds.width / 2
        subIcon.load(urlString: finalUrlString, indicator: nil)
    }
}
