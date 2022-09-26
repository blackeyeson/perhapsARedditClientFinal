//
//  TableViewCellTypeShortened.swift
//  projRed
//
//  Created by a on 29.08.22.
//

import UIKit

class TableViewCellTypeShortened: UITableViewCell {

    // MARK: - Views
    @IBOutlet var title: UILabel!
    @IBOutlet var userAndSubreddit: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var thumbnail: UIImageView!
    
    // MARK: - Fields
    var id = ""

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let threeDotsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeDotsTap(_:)))
        self.addGestureRecognizer(threeDotsTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Actions

    @objc func handleThreeDotsTap(_ sender: UITapGestureRecognizer? = nil) {
        let defaults = UserDefaults.standard
        var hiddenPosts: [String] = defaults.object(forKey: "hiddenPosts") as? [String] ?? []
        if id != "" {
            hiddenPosts = hiddenPosts.filter { $0 != id }
            defaults.set(hiddenPosts, forKey: "hiddenPosts")
            NotificationCenter.default.post(name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
        }

    }
    
    // MARK: - configuration
    func configure(with model: PostForTable) {
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        thumbnail.layer.cornerRadius = 8
        
        title.text = model.postTitle
        userAndSubreddit.text = "\(model.oPUsername) | \(model.subreddit)"
        if let url = model.thumbnail {
            thumbnail.load(urlString: url, indicator: indicator)
        }
        id = model.id

    }
}
