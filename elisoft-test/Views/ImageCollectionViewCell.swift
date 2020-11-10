//
//  ImageCollectionViewCell.swift
//  elisoft-test
//
//  Created by Mark G on 09/11/2020.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 7
    }
    
    func configure(for index: Int, size: CGSize) {
        let manager = StorageManager.shared
        
        // Reset ui
        loadingActivityIndicatorView.stopAnimating()
        imageView.image = nil
        
        // Get image from cached if has
        if let image = manager.cached(at: index) {
            imageView.image = image
            return
        }
        
        // Fetch image
        loadingActivityIndicatorView.startAnimating()
        manager.get(at: index, size: size) { [weak self] in
            
            guard let `self` = self
            else { return }
            
            self.loadingActivityIndicatorView.stopAnimating()
            self.imageView.image = $0
        }
    }
}
