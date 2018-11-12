//
//  NewsFooterView.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsFooterView: BaseSupplementaryView {    
    private let counterLabel = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    init() {
        super.init(frame: .zero)
        self.configureViews()
        self.configureAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }        
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(counterLabel)
        addSubview(activityIndicatorView)
    }
    
    override func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? NewsFooterViewModel else { return }        
        counterLabel.frame = viewModel.layoutModel.frame
        activityIndicatorView.frame = viewModel.layoutModel.frame
        counterLabel.text = viewModel.counterString
    }
    
    private func configureAppearance() {
        Appearance.applyFor(footerLabel: counterLabel)
    }
}
