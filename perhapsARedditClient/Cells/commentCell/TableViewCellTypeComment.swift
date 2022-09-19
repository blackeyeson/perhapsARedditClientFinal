//
//  TableViewCellTypeComment.swift
//  perhapsARedditClient
//
//  Created by a on 20.09.22.
//

import UIKit

class TableViewCellTypeComment: UITableViewCell {

    @IBOutlet var user: UILabel!
    @IBOutlet var textBody: UILabel!
    @IBOutlet var votes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(user: String, bodyText: String, votes: String) {
        self.user.text = user
        self.textBody.text = bodyText
        self.votes.text = votes
    }
}
