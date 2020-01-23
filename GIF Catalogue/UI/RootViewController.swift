//
//  ViewController.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {

    init() {
        
        let pVC = PopularViewController()
        super.init(rootViewController: pVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

