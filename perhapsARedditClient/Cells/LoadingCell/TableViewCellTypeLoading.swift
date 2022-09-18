//
//  TableViewCellTypeLoading.swift
//  perhapsARedditClient
//
//  Created by a on 18.09.22.
//

import UIKit

class TableViewCellTypeLoading: UITableViewCell {

    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
