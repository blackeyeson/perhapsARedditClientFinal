//
//  UIImageView+Extension.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

//import Foundation

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, indicator: UIActivityIndicatorView) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        indicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "loadingError")
                        indicator.stopAnimating()
                    }
                }
            }
        }
    }
}
