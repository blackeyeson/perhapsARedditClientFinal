//
//  TableViewCellType1.swift
//  projRed
//
//  Created by a on 06.08.22.
//

import UIKit

class TableViewCellTypeFull: UITableViewCell {
    
    // MARK: - Static Fields
    
    static var identifier: String { .init(describing: self) }
    
    // MARK: - Fields
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet var upDoot: UIImageView!
    @IBOutlet var downDoot: UIImageView!
    @IBOutlet var voteCount: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var subredditIcon: UIImageView!
    @IBOutlet var subreddit: UILabel!
    @IBOutlet var oPUsername: UILabel!
    @IBOutlet var timePassed: UILabel!
    @IBOutlet var topBarView: UIView!
    
    var isRed = false
    var isBlue = false
    var index = -1
    var data: Post? = nil
    //    var aboutPage: Stuff? = nil
    weak var delegate: MainScreenViewController?
    var currnetTime = Date()
    
//    // MARK: - ObjectLifecycle
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    
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
        //        if delegate?.redditData != nil && index != -1{
        //            delegate!.contractionStats += [index]
        //            delegate!.tableView.reloadData()
        //        }
    }
    // MARK: - Methods
    
    func configure(with model: PostForTable) {
        config()
    }
    
    func config() {
        //        if data != nil {
        //            picture.load(url: data!.thumbnail)
        //            postTitle.text = data!.title
        //            oPUsername.text = "u/\(data!.author)"
        //
        //            //set time component
        //            let epocTime = Int(TimeInterval(data!.created_utc))
        //            let currentTime = Int(Date().timeIntervalSince1970)
        //            var differance = currentTime - epocTime
        //
        //            if differance / 60 < 60 && differance > 0  {
        //                timePassed.text = "\(differance / 60)min"
        //            } else {
        //                differance = differance / 3600
        //                if differance < 24 && differance > 0 {
        //                    timePassed.text = "\(differance)h"
        //                } else {
        //                    differance = differance / 24
        //                    if differance < 30 && differance > 0  {
        //                        timePassed.text = "\(differance)d"
        //                    } else {
        //                        differance = differance / 30
        //                        if differance < 12 && differance > 0  {
        //                            timePassed.text = "\(differance)m"
        //                        } else {
        //                            differance = differance / 12
        //                            timePassed.text = "\(differance)y"
        //                        }
        //                    }
        //                }
        //            }
        
        
        
        
        
//        upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//        isRed = false
//        isBlue = false
        
        //            if data!.score > 999 {
        //                voteCount.text = "\(round(Double(data!.score)/100)/10)K"
        //            } else { voteCount.text = "\(data!.score)" }
        //            if delegate != nil {
        //                subreddit.text = "r/\(delegate!.subreddit)"
        //            }
        //            if aboutPage != nil {
        ////                subredditIcon.load(url: URL(string: aboutPage!.community_icon)!)
        ////                delegate!.coloredBar.backgroundColor = UIColor(hex: aboutPage!.primary_color)
        //            }
        //        }
        
    }
    // MARK: - Private Methods
}
