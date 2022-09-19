//
//  TableViewCellType1.swift
//  projRed
//
//  Created by a on 06.08.22.
//

import UIKit
import AVKit

class TableViewCellTypeFull: UITableViewCell {
    
    // MARK: - Fields
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
    @IBOutlet var shareImage: UIImageView!
    @IBOutlet var commentsImage: UIImageView!
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var mediaImageViewHeightCOnstraint: NSLayoutConstraint!
    @IBOutlet var mediaImageViewHeightConstraintEqual: NSLayoutConstraint!
    @IBOutlet var mediaImageViewHeightConstraintEqualOrLess: NSLayoutConstraint!
    @IBOutlet var subtextLabel: UILabel!
    
    var mode = 0
    var trueWidth: CGFloat? = nil
    weak var delegate: MainScreenDisplayLogic?
    var isRed = false
    var isBlue = false
    var id = ""
    var stringUrl = ""
    var vidStringUrl = ""
    var subText = ""
    var currnetTime = Date()
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    var playerLooper: NSObject?
    var indicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGestures()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func handleUpTap(_ sender: UITapGestureRecognizer? = nil) {
        if isRed { vote(status: 0); updateVoteStatusInDefaults(status: 0) }
        else { vote(status: 1); updateVoteStatusInDefaults(status: 1) }
    }
    
    @objc func handleDownTap(_ sender: UITapGestureRecognizer? = nil) {
        if isBlue { vote(status: 0); updateVoteStatusInDefaults(status: 0) }
        else { vote(status: -1); updateVoteStatusInDefaults(status: -1) }
    }
    
    @objc func subtextTap(_ sender: UITapGestureRecognizer? = nil) {
        if subText == "" { return }
        if let url = URL(string: subText) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func handleThreeDotsTap(_ sender: UITapGestureRecognizer? = nil) {
        addToHiddenPosts()
    }
    
    @objc func shareTap(_ sender: UITapGestureRecognizer? = nil) {
        if self.stringUrl == "" { return }
        delegate?.popupShareMenu(url: stringUrl)
    }
    
    @objc func commentsTap(_ sender: UITapGestureRecognizer? = nil) {
        if self.id == "" { return }
        delegate?.popupCommentsView(id: id)
    }
    
    func configure(with model: PostForTable) {
        
        AddIndicator(to: mediaImageView)
        updateVoteStatusColors()
        getAndSetUpvoteStatus(id: model.id)
        universalCellSetup(with: model)
        //MARK: - set media acording to Mode
        switch mode {
        case 1:
            let isGif = stringUrl.contains(".gif") && !stringUrl.contains(".gifv")
            DispatchQueue.main.async {
                if isGif { self.setGif(urlString: self.stringUrl) }
                else { self.mediaImageView.load(urlString: self.stringUrl, indicator: self.indicator) }
            }
        case 3:
            DispatchQueue.main.async {
                self.playvideo(videourl: self.vidStringUrl)
            }
        case 4:
            if subText != "" { setText(text: subText) }
        default:
            setText(text: stringUrl)
        }
        
    }
    
    //MARK: - set Gif
    func setGif(urlString: String) { mediaImageView.loadGif(urlString: urlString, indicator: indicator) }
    
    //MARK: - set Text
    func setText(text: String) {
        //changing mediaImageView height&picture to fit text
        if mediaImageView.image == nil {
            let smallImage = UIImage(named: "blackSmoll")
            let newHeight = smallImage?.size.height ?? 40
            mediaImageViewHeightConstraintEqualOrLess.constant = newHeight
            mediaImageViewHeightConstraintEqual.constant = newHeight
            mediaImageViewHeightCOnstraint.constant = newHeight
            mediaImageView.image = smallImage
        }
        //setting text
        subText = text
        subtextLabel.text = subText
        indicator?.stopAnimating()
    }
    
    //MARK: - play Video FromURL
    func playvideo(videourl: String) {
        // Create a URL
        guard let url = URL(string: videourl) else {
            self.setText(text: videourl)
            return
        }
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Assign an array of 1 item to AVQueuePlayer
        self.videoPlayer = AVQueuePlayer(items: [item])
        
        // Loop the video
        self.playerLooper = AVPlayerLooper(player: self.videoPlayer! as! AVQueuePlayer, templateItem: item)
        
        // Create the layer
        self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
        
        // Adjust the size and frame
        if let videoPLayer = self.videoPlayerLayer {
            mediaImageView.layer.addSublayer(videoPLayer)
            AddIndicator(to: mediaImageView)
            let bounds = self.mediaImageView.bounds
            videoPLayer.frame = bounds
            videoPLayer.masksToBounds = true
            videoPLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
        // Add it to the view and play it
        self.videoPlayer?.play()
        indicator?.stopAnimating()
    }
    
    //MARK: - save PostId to UserDefaults
    func addToHiddenPosts() {
        let defaults = UserDefaults.standard
        var hiddenPosts: [String] = defaults.object(forKey: "hiddenPosts") as? [String] ?? []
        if id != "" {
            hiddenPosts += [id]
            defaults.set(hiddenPosts, forKey: "hiddenPosts")
            NotificationCenter.default.post(name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
        }
    }
    
    //MARK: - Setup functions
    func AddIndicator(to view: UIView) {
        indicator?.removeFromSuperview()
        let newIndicator = UIActivityIndicatorView(style: .whiteLarge)
        newIndicator.hidesWhenStopped = true
        mediaImageView.addSubview(newIndicator)
        
        newIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: newIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: newIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            horizontalConstraint,
            verticalConstraint
        ])
        newIndicator.startAnimating()
        indicator = newIndicator
    }
    
    func addGestures() {
        let tapUp = UITapGestureRecognizer(target: self, action: #selector(self.handleUpTap(_:)))
        upDoot.addGestureRecognizer(tapUp)
        
        let tapDown = UITapGestureRecognizer(target: self, action: #selector(self.handleDownTap(_:)))
        downDoot.addGestureRecognizer(tapDown)
        
        let threeDotsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeDotsTap(_:)))
        topBarView.addGestureRecognizer(threeDotsTap)
        
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(self.shareTap(_:)))
        shareImage.addGestureRecognizer(shareTap)
        
        let subtextTap = UITapGestureRecognizer(target: self, action: #selector(self.subtextTap(_:)))
        subtextLabel.addGestureRecognizer(subtextTap)
        
        let commentsTap = UITapGestureRecognizer(target: self, action: #selector(self.commentsTap(_:)))
        commentsImage.addGestureRecognizer(commentsTap)
    }
    
    func setHeightFromAspect(contentWidth: CGFloat, contentHeight: CGFloat) {
        guard let trueWidth = trueWidth else {return}
        let multiplier = contentWidth / trueWidth
        var trueHeight = contentHeight / multiplier
        
        if trueHeight > 800 { trueHeight = 800 }
        mediaImageViewHeightCOnstraint.constant = trueHeight
        mediaImageViewHeightConstraintEqual.constant = trueHeight
        mediaImageViewHeightConstraintEqualOrLess.constant = trueHeight
    }
    
    func universalCellSetup(with model: PostForTable) {
        subredditIcon.layer.cornerRadius = 8
        postTitle.text = model.postTitle
        subreddit.text = model.subreddit
        oPUsername.text = model.oPUsername
        domain.text = model.domain
        timePassed.text = model.timePassed
        voteCount.text = model.voteCount
        subText = ""
        subtextLabel.text = subText
        mediaImageView.image = nil
        videoPlayerLayer?.opacity = 0
        videoPlayer?.pause()
        id = model.id
        stringUrl = model.picture ?? ""
        vidStringUrl = model.VideoUrlString ?? ""
        subText = model.bodyText
        
        subredditIcon.image = UIImage(named: "logonLogo")
        subredditIcon.load(urlString: model.iconUrlString, indicator: nil)
        mediaImageView.image = nil
    }
    
    func getAndSetUpvoteStatus(id: String) {
        let defaults = UserDefaults.standard
        guard let postVoteStatuses: [String: Int] = defaults.object(forKey: "postVoteStatuses") as? [String: Int]
        else { return }
        guard let status = postVoteStatuses[id]
        else { return }
        vote(status: status)
    }
    
    func vote(status: Int) {
        switch status {
        case -1:
            isBlue = true
            isRed = false
        case 1:
            isBlue = false
            isRed = true
        default:
            isBlue = false
            isRed = false
        }
        updateVoteStatusColors()
    }
    
    func updateVoteStatusColors() {
        if isBlue { downDoot.backgroundColor = UIColor(red: 0.58, green: 0.58, blue: 1.00, alpha: 1.00) }
        else { downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0) }
        
        if isRed { upDoot.backgroundColor = UIColor(red: 1.00, green: 0.55, blue: 0.38, alpha: 1.00) }
        else { upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0) }
    }
    
    func updateVoteStatusInDefaults(status: Int) {
        let defaults = UserDefaults.standard
        guard var postVoteStatuses: [String: Int] = defaults.object(forKey: "postVoteStatuses") as? [String: Int]
        else {
            var defaultStstsDict: [String: Int] = [:]
            defaultStstsDict[id] = status
            defaults.set(defaultStstsDict, forKey: "postVoteStatuses")
            return
        }
        postVoteStatuses[id] = status
        defaults.set(postVoteStatuses, forKey: "postVoteStatuses")
    }
}

