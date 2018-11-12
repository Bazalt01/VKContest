//
//  CountersLayoutModel.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct CounterCoupleFrames {
    var button: CGRect
    var label: CGRect
}

class CountersLayoutModel: LayoutModel {
    let likes: CounterCoupleFrames
    let comments: CounterCoupleFrames
    let reposts: CounterCoupleFrames
    let views: CounterCoupleFrames
    
    init(likes: CounterCoupleFrames, comments: CounterCoupleFrames, reposts: CounterCoupleFrames, views: CounterCoupleFrames, frame: CGRect) {
        self.likes = likes
        self.comments = comments
        self.reposts = reposts
        self.views = views
        super.init(frame: frame)
    }
}
