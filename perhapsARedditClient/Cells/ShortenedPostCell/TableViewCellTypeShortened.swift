//
//  TableViewCellTypeShortened.swift
//  projRed
//
//  Created by a on 29.08.22.
//

import UIKit

class TableViewCellTypeShortened: UITableViewCell {


    // MARK: - Static Fields

    static var identifier: String { .init(describing: self) }

    // MARK: - Fields
    @IBOutlet var title: UILabel!
    @IBOutlet var userAndSubreddit: UILabel!

    var data: Post? = nil
    var index = -1
    weak var delegate: MainScreenViewController? = nil

    // MARK: - ObjectLifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        config()
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
//        if delegate?.redditData != nil && index != -1{
//            delegate!.contractionStats = delegate!.contractionStats.filter { $0 != index }
//            delegate!.tableView.reloadData()
//        }
    }
    func config() {
//        if delegate != nil {
//            title.text = delegate!.redditData?.data.children[index].data.title
//            userAndSubreddit.text = "u/\(delegate!.redditData!.data.children[index].data.author) | r/\(delegate!.subreddit)"
//        } else { print("incorrect usage") }
    }

}
