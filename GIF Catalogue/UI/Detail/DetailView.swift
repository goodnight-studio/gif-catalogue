//
//  DetailView.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 2/5/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit
import FLAnimatedImage

class DetailView: UIView {
    
    let imageView = FLAnimatedImageView()
    let activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        
        activityIndicator.frame.size.width = 32
        activityIndicator.frame.size.height = 32
        activityIndicator.frame.origin.x = bounds.width / 2 - 16
        activityIndicator.frame.origin.y = bounds.height / 2 - 16
        
        imageView.frame = bounds
        imageView.frame.inset(by: safeAreaInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
