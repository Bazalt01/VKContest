//
//  GroupHeaderLayoutModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class GroupHeaderLayoutModel: LayoutModel {
    let avatarFrame: CGRect
    let nameFrame: CGRect
    let dateFrame: CGRect
    
    init(avatarFrame: CGRect, nameFrame: CGRect, dateFrame: CGRect, frame: CGRect) {
        self.avatarFrame = avatarFrame
        self.nameFrame = nameFrame
        self.dateFrame = dateFrame
        super.init(frame: frame)
    }
}
