//
//  GIFCollectionViewCell.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class GIFCollectionViewCell: UICollectionViewCell {
    
    var gif: GIF? {
        didSet {
            if let url = gif?.image.fixedWidthUrl {
                setImage(url: url)
            }
        }
    }
    
    let imageView = UIImageView()
    
    static var identifier: String {
        return "GIFCollectionViewCell"
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    func setImage(url: URL) {
        
        DispatchQueue.global().async {
            
            let data = try? Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
                self.imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
    }
    
    func setSelected() {
        backgroundColor = .systemGray5
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 2
    }
    
    func setDeselected() {
        backgroundColor = .clear
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// FROM: https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//extension UIImageView {
//    public func imageFromUrl(urlString: String) {
//        if let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
//                (response: URLResponse?, data: Data?, error: Error?) -> Void in
//                if let imageData = data as Data? {
//                    self.image = UIImage(data: imageData)
//                }
//            }
//        }
//    }
//}
