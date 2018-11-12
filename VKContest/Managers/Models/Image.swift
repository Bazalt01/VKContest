//
//  Image.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

struct Image {
    private(set) var url: String
    private(set) var originalSize: CGSize
    
    init(url: String, size: CGSize) {
        self.url = url
        self.originalSize = size
    }
}
