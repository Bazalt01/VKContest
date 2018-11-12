//
//  NewsLayoutModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class NewsLayoutModel: LayoutModel {
    let groupHeaderLayoutModel: GroupHeaderLayoutModel
    let textFrame: CGRect
    let countersLayoutModel: CountersLayoutModel
    let attachmentLayoutModel: LayoutModel?
    
    init(groupHeaderLayoutModel: GroupHeaderLayoutModel, textFrame: CGRect, countersLayoutModel: CountersLayoutModel, attachmentLayoutModel: LayoutModel?, frame: CGRect) {
        self.groupHeaderLayoutModel = groupHeaderLayoutModel
        self.textFrame = textFrame
        self.countersLayoutModel = countersLayoutModel
        self.attachmentLayoutModel = attachmentLayoutModel
        super.init(frame: frame)
    }
}
