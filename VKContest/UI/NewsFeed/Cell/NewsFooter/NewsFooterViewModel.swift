//
//  NewsFooterViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class NewsFooterViewModel: BaseViewModel {
    var counter = 0
    var counterString: String {
        return String.vkc_formatCountNews(counter: counter)
    }
    
    init() {
        super.init(viewClass: NewsFooterView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        let frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: AppearanceSize.footerHeight))
        layoutModel = LayoutModel(frame: frame)
    }
}
