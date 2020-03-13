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
    let searchBar = UISearchBar()
    
    var gifs: [GIF]?
    
    var isToolbarHidden = false

    override func loadView() {
        
        view = popularView
        
        title = "Popular GIFs"
        
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Popular GIFs"
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        popularView.collectionView.dragInteractionEnabled = true
        popularView.collectionView.dragDelegate = self
        
        popularView.collectionView.delegate = self
        popularView.collectionView.dataSource = self
        
        popularView.collectionView.register(GIFCollectionViewCell.self, forCellWithReuseIdentifier: GIFCollectionViewCell.identifier)
        
        GiphyApi.getTrending(completion: {
            self.updateInterface()
        }, errorHandler: handleError)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PopularViewController.toggleSearch), name: NSNotification.Name(rawValue: "com.geofcrowl.gif-catalogue.toggleSearch"), object: [])
        
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(isToolbarHidden, animated: false)
        #endif
    }
    
    @objc func toggleSearch() {
        
        isToolbarHidden.toggle()
        
        navigationController?.setNavigationBarHidden(isToolbarHidden, animated: true)
        
        if isToolbarHidden {
            searchBar.resignFirstResponder()
        } else {
            searchBar.becomeFirstResponder()
        }
        
        updateInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchBar.resignFirstResponder()
        
        let cells = popularView.collectionView.visibleCells
        
        for cell in cells {
            
            guard let gifCell = cell as? GIFCollectionViewCell else { continue }
            gifCell.imageView.stopAnimating()
        }
        
        super.viewDidAppear(animated)
        
    }
    
    func updateInterface(showGifs: [GIF]? = nil) {
        
        popularView.activityIndicator.stopAnimating()
        
        if let _gifs = showGifs {
            
            gifs = _gifs
            
        } else {
            
            gifs = AppData.trendingGifs
        }
        
        print("gif count:", gifs?.count ?? "nil")
        popularView.collectionView.reloadData()
    }
    
    func handleError(_ error: Error?) {
        print("error:", error?.localizedDescription ?? "nil")
    }
}

extension PopularViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("Searching:", searchBar.text ?? "nil")
        
        guard let query = searchBar.text else { return }
        
        self.updateInterface(showGifs: [])
        popularView.activityIndicator.startAnimating()
        
        GiphyApi.search(query: query, completion: {
            self.updateInterface(showGifs: AppData.searchGifs)
        }, errorHandler: handleError)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        updateInterface()
    }
}

extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected", indexPath)
        
        if let gif = gifs?[indexPath.row] {
            let dVC = DetailViewController(withGIF: gif)
            navigationController?.pushViewController(dVC, animated: true)
        }
        
//        if let cell = collectionView.cellForItem(at: indexPath) {
//
//            guard let cell = cell as? GIFCollectionViewCell else { return }
//            cell.setSelected()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
//        if let cell = collectionView.cellForItem(at: indexPath) {
//
//            guard let cell = cell as? GIFCollectionViewCell else { return }
//            cell.setDeselected()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFCollectionViewCell.identifier, for: indexPath) as! GIFCollectionViewCell
        
        if let gif = gifs?[indexPath.row] {
            cell.gif = gif
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

extension PopularViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        guard let gif = gifs?[indexPath.row] else { return [] }
        
        let data = gif.image.originalImageData
        let identifier: String = gif.image.originalImage!.cgImage?.utType! as! String
        
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: identifier, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = gif
        
        return [dragItem]
    }
    
    
}
