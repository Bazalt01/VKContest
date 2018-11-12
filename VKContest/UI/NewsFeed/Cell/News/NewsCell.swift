//
//  NewsCell.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsCell: BaseCell {        
    private let groupHeaderView = GroupHeaderView()
    private let textView = UITextView()
    private let countersView = CountersView()
    var attachmentView: (UIView & View)?
    
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
    
    func configureViews() {
        contentView.addSubview(groupHeaderView)
        contentView.addSubview(textView)
        contentView.addSubview(countersView)
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
    }
    
    // MARK: - Private
    
    override func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? NewsCellModel else { return }
        groupHeaderView.viewModel = viewModel.groupHeaderViewModel
        textView.text = viewModel.text
        countersView.viewModel = viewModel.countersViewModel
        attachmentView?.viewModel = viewModel.attachmentViewModel
        
        guard let layoutModel = viewModel.layoutModel as? NewsLayoutModel else { return }
        textView.frame = layoutModel.textFrame                
    }
    
    private func configureAppearance() {
        Appearance.applyFor(contentLabel: textView)
        Appearance.applyFor(cell: self)
    }
}
