//
//  UIImageView+Extension.swift
//  perhapsARedditClient
//
//  Created by a on 03.09.22.
//

//import Foundation

import Foundation
import UIKit
import ImageIO

extension UIImageView {
    func load(urlString: String, indicator: UIActivityIndicatorView?) {
        guard let url = URL(string: urlString) else { print("err/imageLoad"); return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.layer.opacity = 1
                        indicator?.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "loadingError")
                        indicator?.stopAnimating()
                    }
                }
            }
        }
    }
}
