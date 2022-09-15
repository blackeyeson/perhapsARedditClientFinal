//
//  TableViewCellType1.swift
//  projRed
//
//  Created by a on 06.08.22.
//

import UIKit
import AVFoundation

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
    @IBOutlet var subtext: UILabel!
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
//    var playerAV: AVPlayer!
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    var playerLooper:NSObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapUp = UITapGestureRecognizer(target: self, action: #selector(self.handleUpTap(_:)))
        upDoot.addGestureRecognizer(tapUp)
        
        let tapDown = UITapGestureRecognizer(target: self, action: #selector(self.handleDownTap(_:)))
        downDoot.addGestureRecognizer(tapDown)
        
        let threeDotsTap = UITapGestureRecognizer(target: self, action: #selector(self.handleThreeDotsTap(_:)))
        topBarView.addGestureRecognizer(threeDotsTap)
        
        let subtextTap = UITapGestureRecognizer(target: self, action: #selector(self.subtextTap(_:)))
        topBarView.addGestureRecognizer(threeDotsTap)
        picture.addGestureRecognizer(subtextTap)

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
            upDoot.backgroundColor = UIColor(red: 1.00, green: 0.55, blue: 0.38, alpha: 1.00)
            downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isRed = true
        }
    }
    
    @objc func handleDownTap(_ sender: UITapGestureRecognizer? = nil) {
        if isBlue {
            downDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isBlue = false
        } else {
            downDoot.backgroundColor = UIColor(red: 0.58, green: 0.58, blue: 1.00, alpha: 1.00)
            upDoot.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            isBlue = true
        }
    }
    
    @objc func subtextTap(_ sender: UITapGestureRecognizer? = nil) {
        if subtext.text == "" { return }
        if let url = URL(string: subtext.text ?? "") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func handleThreeDotsTap(_ sender: UITapGestureRecognizer? = nil) {
        print("a")
        let defaults = UserDefaults.standard
        var hiddenPosts: [String] = defaults.object(forKey: "hiddenPosts") as? [String] ?? []
        if id != "" {
            hiddenPosts += [id]
            defaults.set(hiddenPosts, forKey: "hiddenPosts")
            NotificationCenter.default.post(name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
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
        subredditIcon.layer.cornerRadius = 8
        postTitle.text = model.postTitle
        subreddit.text = model.subreddit
        oPUsername.text = model.oPUsername
        domain.text = model.domain
        timePassed.text = model.timePassed
        voteCount.text = model.voteCount
        subtext.text = ""
        videoPlayerLayer?.opacity = 0
        videoPlayer?.pause()
        id = model.id
        
        subredditIcon.image = UIImage(named: "logonLogo")
        subredditIcon.load(urlString: model.iconUrlString, indicator: nil)
        
        let StringUrl = model.picture ?? ""
        let vidStringUrl = model.VideoUrlString ?? ""
        let bodyText = model.bodyText
        
        let isPicture = StringUrl.contains(".jpg") || StringUrl.contains("png")
        let isGif = model.isGif && !StringUrl.contains(".gifv")
        let isVideo = vidStringUrl.contains(".mp4")
        let isText = !isPicture && !model.isVideo && !model.isGif
        let isBodyText = model.bodyText != ""

        if isVideo { playvideo(videourl: vidStringUrl); return }

        if isGif { setGif(urlString: StringUrl); return }
        
        if isPicture { picture.load(urlString: StringUrl, indicator: indicator); return }
                            
        if isText { setText(text: StringUrl); return }
        
        if isBodyText { setText(text: bodyText); return }
        
        setText(text: StringUrl)
    }
    
    func setGif(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("err/setGif")
            setText(text: urlString)
            return
        }
        DispatchQueue.global().async { [weak self] in
            let image = UIImage.gifImageWithURL("\(url)")
            DispatchQueue.main.async {
                self?.picture.image = image
                self?.indicator.stopAnimating()
            }
        }
    }
    
    func setText(text: String) {
        subtext.text = text
        picture.image = UIImage(named: "blackSmoll")
        picture.layer.opacity = 0
        indicator.stopAnimating()
    }
    
    func playvideo(videourl: String) {
        
        picture.layer.opacity = 1
        picture.image = UIImage(named: "black")
        // Create a URL
        guard let url = URL(string: videourl) else {
            picture.layer.opacity = 0
            setText(text: videourl)
            return
        }
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Assign an array of 1 item to AVQueuePlayer
        videoPlayer = AVQueuePlayer(items: [item])
        
        // Loop the video
        playerLooper = AVPlayerLooper(player: videoPlayer! as! AVQueuePlayer, templateItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = picture.bounds
        videoPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        picture.layer.addSublayer(videoPlayerLayer!)

        // Add it to the view and play it
        indicator.stopAnimating()
        videoPlayerLayer?.opacity = 1
        videoPlayer?.play()
    }
}
