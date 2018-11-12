//
//  NewsHeaderLayoutModel.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class NewsHeaderLayoutModel: LayoutModel {
    let searchFrame: CGRect
    let searchImageFrame: CGRect
    let searchTextFieldFrame: CGRect
    let avatarFrame: CGRect
    
    init(searchFrame: CGRect, searchImageFrame: CGRect, searchTextFieldFrame: CGRect, avatarFrame: CGRect, frame: CGRect) {
        self.searchFrame = searchFrame
        self.searchImageFrame = searchImageFrame
        self.searchTextFieldFrame = searchTextFieldFrame
        self.avatarFrame = avatarFrame
        super.init(frame: frame)
    }
}
