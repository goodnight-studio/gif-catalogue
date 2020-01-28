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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected", indexPath)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            guard let cell = cell as? GIFCollectionViewCell else { return }
            cell.setSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            guard let cell = cell as? GIFCollectionViewCell else { return }
            cell.setDeselected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFCollectionViewCell.identifier, for: indexPath) as! GIFCollectionViewCell
        
        if let gif = AppData.trendingGifs?[indexPath.row] {
            cell.gif = gif
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

        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (menuElement) -> UIMenu? in
            
            let cell = collectionView.cellForItem(at: indexPath)
            return self.makeContextMenu(sender: self, sourceView: cell)
        }
        
        return config
    }
    
    func makeContextMenu(sender: UIViewController, sourceView: UICollectionViewCell?) -> UIMenu? {
        
        if let cell = sourceView as? GIFCollectionViewCell {
            
            if let gif = cell.gif {
                
                let copyURL = UIAction(title: "Copy GIF URL", image: UIImage(systemName: "doc.on.doc"), identifier: UIAction.Identifier("copy-url")) { (action) in

                    UIPasteboard.general.string = gif.urlStr
                    UIPasteboard.general.url = gif.url
                }
                
                let shareURL = UIAction(title: "Share GIF", image: UIImage(systemName: "square.and.arrow.up"), identifier: UIAction.Identifier("share-url")) { action in
                    
                    let aVC = UIActivityViewController(activityItems: [gif.url], applicationActivities: [SafariActivity()])
                    
                    // try to use a source view, but default to sender's view if that fails
                    // such as a tableview that scrolls away
                    if let sourceView = sourceView {
                        aVC.popoverPresentationController?.sourceView = sourceView
                        aVC.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.width / 4, y: sourceView.bounds.height / 4, width: sourceView.bounds.width / 2, height: sourceView.bounds.height / 2)
                        sender.present(aVC, animated: true, completion: {})
                    }
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, children: [copyURL, shareURL])
            }
        }
        
        return nil
        
    }
}
