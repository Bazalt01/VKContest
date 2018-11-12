//
//  NewsCellWithPhotoGallery.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsCellWithPhotoGallery: NewsCell {
    private let photoGalleryView = PhotoGalleryView()
    
    override func configureViews() {
        super.configureViews()
        attachmentView = photoGalleryView
        contentView.addSubview(photoGalleryView)
    }
}
