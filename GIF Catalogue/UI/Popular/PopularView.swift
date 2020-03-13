//
//  PopularView.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class PopularView: UIView {
    
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    let activityIndicator = UIActivityIndicatorView()
    
    var itemDimension: CGFloat {
        return bounds.width > 450 ? 200 : 100
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        layout.itemSize = CGSize(width: itemDimension, height: itemDimension)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        addSubview(collectionView)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
    }
    
    override func layoutSubviews() {
        
        activityIndicator.frame.size.width = 32
        activityIndicator.frame.size.height = 32
        activityIndicator.frame.origin.x = (bounds.width / 2) - 16
        activityIndicator.frame.origin.y = (bounds.height / 2) - 16
        
        collectionView.frame = bounds
        collectionView.contentInset = UIEdgeInsets(
            top: 16,
            left: safeAreaInsets.left + 16,
            bottom: safeAreaInsets.bottom + 16,
            right: safeAreaInsets.right + 16)
        layout.itemSize = CGSize(width: itemDimension, height: itemDimension)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
