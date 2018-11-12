//
//  CountersViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class CountersViewModel: BaseViewModel {
    private(set) var likes: String
    private(set) var comments: String
    private(set) var reposts: String
    private(set) var views: String
    
    init(counters: Counters) {
        self.likes = String.vkc_formatCounter(counter: counters.likes)
        self.comments = String.vkc_formatCounter(counter: counters.comments)
        self.reposts = String.vkc_formatCounter(counter: counters.reposts)
        self.views = String.vkc_formatCounter(counter: counters.views)
        super.init(viewClass: CountersView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        let buttonDistance: CGFloat = 46
        let likeButtonFrame = CGRect(origin: .zero, size: AppearanceSize.buttonSize)
        
        let counterLabelSize = CGSize(width: 40, height: 17)
        let counterLabelY = (likeButtonFrame.height - counterLabelSize.height) / 2.0
        
        let likeLabelOrigin = CGPoint(x: likeButtonFrame.maxX, y: counterLabelY)
        let likeLabelFrame = CGRect(origin: likeLabelOrigin, size: counterLabelSize)
        
        let commentButtonOrigin = CGPoint(x: likeButtonFrame.maxX + buttonDistance, y: 0)
        let commentButtonFrame = CGRect(origin: commentButtonOrigin, size: AppearanceSize.buttonSize)
        
        let commentLabelOrigin = CGPoint(x: commentButtonFrame.maxX, y: counterLabelY)
        let commentLabelFrame = CGRect(origin: commentLabelOrigin, size: counterLabelSize)
        
        let repostButtonOrigin = CGPoint(x: commentButtonFrame.maxX + buttonDistance, y: 0)
        let repostButtonFrame = CGRect(origin: repostButtonOrigin, size: AppearanceSize.buttonSize)
        
        let repostLabelOrigin = CGPoint(x: repostButtonFrame.maxX, y: counterLabelY)
        let repostLabelFrame = CGRect(origin: repostLabelOrigin, size: counterLabelSize)
        
        var viewsLabelOrigin = CGPoint(x: frame.width, y: counterLabelY)
        var viewsLabelFrame = CGRect(origin: viewsLabelOrigin, size: .zero)
        
        if views.count > 0 {
            let attr = [NSAttributedString.Key.font : AppearanceFont.inaCounterLabel]
            let textAttr = NSAttributedString(string: views, attributes: attr)
            var textWidth = textAttr.boundingRect(with: CGSize(width: 100, height: 100), options: fittingOptions, context: nil).size.width + 2
            textWidth = round(textWidth)
            viewsLabelOrigin = CGPoint(x: frame.width - textWidth, y: counterLabelY)
            viewsLabelFrame = CGRect(origin: viewsLabelOrigin, size: CGSize(width: textWidth, height: counterLabelSize.height))
        }
        
        let viewsImageWidth = AppearanceSize.buttonSize.width - 6
        let viewsImageViewOrigin = CGPoint(x: viewsLabelFrame.minX - viewsImageWidth, y: 0)
        let viewsImageViewFrame = CGRect(origin: viewsImageViewOrigin, size: CGSize(width: viewsImageWidth, height: AppearanceSize.buttonSize.height))
        
        let totalSize = CGSize(width: frame.width, height: AppearanceSize.buttonSize.height)
        let frame = CGRect(origin: frame.origin, size: totalSize)
        
        layoutModel = CountersLayoutModel(likes: CounterCoupleFrames(button: likeButtonFrame, label: likeLabelFrame),
                                          comments: CounterCoupleFrames(button: commentButtonFrame, label: commentLabelFrame),
                                          reposts: CounterCoupleFrames(button: repostButtonFrame, label: repostLabelFrame),
                                          views: CounterCoupleFrames(button: viewsImageViewFrame, label: viewsLabelFrame),
                                          frame: frame)
    }
}
