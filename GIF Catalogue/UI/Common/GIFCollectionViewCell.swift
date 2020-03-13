//
//  GIFCollectionViewCell.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit
import FLAnimatedImage

fileprivate extension Selector {
    static let hovering = #selector(GIFCollectionViewCell.hovering(_:))
}

class GIFCollectionViewCell: UICollectionViewCell {
    
    var gif: GIF? {
        didSet {
            gif?.image.loadFixedWidthData(completion: { (data) in
                
                self.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.stopAnimating()
            })
        }
    }
    
    let imageView = FLAnimatedImageView()
    var hoverGesture: UIHoverGestureRecognizer!
    
    static var identifier: String {
        return "GIFCollectionViewCell"
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(imageView)
        
        hoverGesture = UIHoverGestureRecognizer(target: self, action: .hovering)
        addGestureRecognizer(hoverGesture)
    }
    
    override func layoutSubviews() {
        imageView.stopAnimating()
        imageView.frame = bounds
    }
    
    @objc func hovering(_ recognizer: UIHoverGestureRecognizer) {
        
        switch recognizer.state {
        case .began, .changed:
            imageView.startAnimating()
        case .ended:
            imageView.stopAnimating()
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
