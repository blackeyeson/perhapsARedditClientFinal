//
//  TableViewCellTypeComment.swift
//  perhapsARedditClient
//
//  Created by a on 20.09.22.
//

import UIKit

class TableViewCellTypeComment: UITableViewCell {

    // MARK: - Views

    @IBOutlet var user: UILabel!
    @IBOutlet var textBody: UILabel!
    @IBOutlet var votes: UILabel!
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - configuration
    func config(user: String, bodyText: String, votes: String) {
        self.user.text = user
        self.textBody.text = bodyText
        self.votes.text = votes
    }
}
