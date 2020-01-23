//
//  PopularViewController.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {
    
    let popularView = PopularView()

    override func loadView() {
        
        view = popularView
        
        title = "Popular GIFs"
        
        popularView.collectionView.delegate = self
        popularView.collectionView.dataSource = self
        
        popularView.collectionView.register(GIFCollectionViewCell.self, forCellWithReuseIdentifier: GIFCollectionViewCell.identifier)
        
        GiphyApi.getTrending(completion: updateInterface, errorHandler: handleError)
    }
    
    func updateInterface() {
        
        popularView.collectionView.reloadData()
    }
    
    func handleError(_ error: Error?) {
        print("Error:", error ?? "error is nil")
    }
}

extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppData.trendingGifs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFCollectionViewCell.identifier, for: indexPath) as! GIFCollectionViewCell
        
        if let gif = AppData.trendingGifs?[indexPath.row] {
            if let url = gif.image.fixedWidthUrl {
//                print(url)
//                cell.imageView.downloaded(from: url)
//                cell.imageView.imageFromUrl(urlString: url.absoluteString)
                cell.setImage(url: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return nil
    }
    
    
}
