//
//  DetailViewController.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 2/5/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit
import FLAnimatedImage

fileprivate extension Selector {
    static let shareImage = #selector(DetailViewController.shareImage(_:))
}

class DetailViewController: UIViewController {
    
    let detailView = DetailView(frame: .zero)
    
    var gif: GIF!
    
    convenience init(withGIF _gif: GIF) {

        self.init()
        
        gif = _gif
        
        title = _gif.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain, target: self, action: .shareImage)
        
        
    }
    
    @objc func shareImage(_ sender: UIBarButtonItem) {

        let aVC = UIActivityViewController(activityItems: [gif.url], applicationActivities: [SafariActivity()])
        
        aVC.popoverPresentationController?.sourceView = detailView
        aVC.popoverPresentationController?.sourceRect = CGRect(
            x: detailView.bounds.width - 16,
            y: 16,
            width: 2,
            height: 2)
        
        self.present(aVC, animated: true, completion: {})
        
    }

    override func loadView() {
        
        view = detailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadGIF()
    }
    
    func loadGIF() {
        
        guard let url = gif.image.originalImageUrl else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        detailView.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
        detailView.imageView.contentMode = .scaleAspectFit
    }

}
