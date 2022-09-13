//
//  TableViewCellType1.swift
//  projRed
//
//  Created by a on 06.08.22.
//

import UIKit

class TableViewCellTypeFull: UITableViewCell {
    
//    // MARK: - Static Fields
//    
//    static var identifier: String { .init(describing: self) }
//    
    // MARK: - Fields
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet var upDoot: UIImageView!
    @IBOutlet var downDoot: UIImageView!
    @IBOutlet var voteCount: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var subredditIcon: UIImageView!
    @IBOutlet var subreddit: UILabel!
    @IBOutlet var domain: UILabel!
    @IBOutlet var oPUsername: UILabel!
    @IBOutlet var timePassed: UILabel!
    @IBOutlet var topBarView: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var isRed = false
    var isBlue = false
    var index = -1
    var data: Post? = nil
    //    var aboutPage: Stuff? = nil
    var id = ""
    var currnetTime = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapUp = UITapGestureRecognizer(target: self, action: #selector(self.handleUpTap(_:)))
        upDoot.addGestureRecognizer(tapUp)
        
        let tapDown = UITapGestureRecognizer(target: self, action: #selector(self.handleDownTap(_:)))
        downDoot.addGestureRecognizer(tapDown)
        
        let threeDotsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeDotsTap(_:)))
        topBarView.addGestureRecognizer(threeDotsTap)
        
        upDoot.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        upDoot.backgroundColor = UIColor.white.withAlphaComponent(0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func handleUpTap(_ sender: UITapGestureRecognizer? = nil) {
        if isRed {
            upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isRed = false
        } else {
            upDoot.backgroundColor = .red
            downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isRed = true
        }
    }
    
    @objc func handleDownTap(_ sender: UITapGestureRecognizer? = nil) {
        if isBlue {
            downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isBlue = false
        } else {
            downDoot.backgroundColor = .blue
            upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isBlue = true
        }
    }
    
    @objc func handleThreeDotsTap(_ sender: UITapGestureRecognizer? = nil) {
        print("a")
        let defaults = UserDefaults.standard
        var hiddenPosts: [String] = defaults.object(forKey: "hiddenPosts") as? [String] ?? []
        if id != "" {
            hiddenPosts += [id]
            defaults.set(hiddenPosts, forKey: "hiddenPosts")
            NotificationCenter.default.post(name: Notification.Name("com.testCompany.Notification.reloadData"), object: nil)
        }
    }
    // MARK: - Methods
    
    func configure(with model: PostForTable) {
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        isRed = false
        isBlue = false
        
        picture.image = UIImage.init(named: "black")
        picture.load(url: model.picture, indicator: indicator)
        postTitle.text = model.postTitle
        subreddit.text = model.subreddit
        oPUsername.text = model.oPUsername
        domain.text = model.domain
        timePassed.text = model.timePassed
        voteCount.text = model.voteCount
        id = model.id
    }
    // MARK: - Private Methods
}
