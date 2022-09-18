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
        guard let url = URL(string: urlString) else { error(indicator: indicator); return }
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { self?.error(indicator: indicator); return }
            
            guard let image = UIImage(data: data) else { self?.error(indicator: indicator); return }
            
            self?.Success(image: image, indicator: indicator)
        }
    }
    
    func error(indicator: UIActivityIndicatorView?) {
        DispatchQueue.main.async {
            guard let image = UIImage(named: "loadingError") else { return }
            self.image = image
            indicator?.stopAnimating()
        }
    }
    
    func Success(image: UIImage, indicator: UIActivityIndicatorView?) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
            indicator?.stopAnimating()
        }
    }
}

extension UIImageView {
    public func loadGif(urlString: String, indicator: UIActivityIndicatorView?) {
        DispatchQueue.global().async {
            let image = UIImage.gifImageWithURL(urlString)
            DispatchQueue.main.async {
                self.image = image
                indicator?.stopAnimating()
            }
        }
    }
}
