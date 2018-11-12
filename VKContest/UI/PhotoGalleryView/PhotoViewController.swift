//
//  PhotoViewController.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let offset = AppearanceSize.externalOffset
        let size = CGSize(width: view.bounds.width - offset * 2, height: view.bounds.height)
        imageView.frame = CGRect(origin: CGPoint(x: offset, y: 0), size: size)
    }
}

