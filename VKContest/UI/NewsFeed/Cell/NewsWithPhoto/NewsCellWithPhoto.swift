//
//  NewsCellWithPhoto.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsCellWithPhoto: NewsCell {    
    private let photoImage = PhotoView()
    
    override func configureViews() {
        super.configureViews()
        attachmentView = photoImage
        contentView.addSubview(photoImage)
    }
}
