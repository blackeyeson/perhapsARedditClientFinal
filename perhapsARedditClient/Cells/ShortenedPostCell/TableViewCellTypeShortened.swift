//
//  TableViewCellTypeShortened.swift
//  projRed
//
//  Created by a on 29.08.22.
//

import UIKit

class TableViewCellTypeShortened: UITableViewCell {

    // MARK: - Fields
    @IBOutlet var title: UILabel!
    @IBOutlet var userAndSubreddit: UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var thumbnail: UIImageView!
    
    var id = ""

    // MARK: - ObjectLifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let threeDotsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeDotsTap(_:)))
        self.addGestureRecognizer(threeDotsTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions

    @objc func handleThreeDotsTap(_ sender: UITapGestureRecognizer? = nil) {
        print("a")
        let defaults = UserDefaults.standard
        var hiddenPosts: [String] = defaults.object(forKey: "hiddenPosts") as? [String] ?? []
        if id != "" {
            hiddenPosts = hiddenPosts.filter { $0 != id }
            defaults.set(hiddenPosts, forKey: "hiddenPosts")
            NotificationCenter.default.post(name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
        }

    }
    func configure(with model: PostForTable) {
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        thumbnail.layer.cornerRadius = 8
//        if let url = model.picture {
//            thumbnail.load(url: url, indicator: indicator)
//        }
        
        title.text = model.postTitle
        userAndSubreddit.text = "\(model.oPUsername) | \(model.subreddit)"
        if let url = model.thumbnail {
            thumbnail.load(urlString: url, indicator: indicator)
        }
        id = model.id

    }
    deinit {
        print("deined")
    }
}
