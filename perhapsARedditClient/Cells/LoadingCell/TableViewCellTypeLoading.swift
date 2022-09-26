//
//  TableViewCellTypeLoading.swift
//  perhapsARedditClient
//
//  Created by a on 18.09.22.
//

import UIKit

class TableViewCellTypeLoading: UITableViewCell {

    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        DispatchQueue.global().async { [weak self] in
            sleep(4)
            DispatchQueue.main.async {
                self?.indicator.stopAnimating(); self?.label.text = "No posts found"
            }
        }
    }
    
}
