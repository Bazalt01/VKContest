//
//  NewsHeaderView.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsHeaderView: BaseSupplementaryView {
    private let avatarImageView = UIImageView()
    private let searchImageView = UIImageView()
    private let searchView = UIView()
    private let searchTextField = UITextField()
    
    init() {
        super.init(frame: .zero)
        self.configureViews()
        self.configureAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
        self.configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(avatarImageView)
        addSubview(searchView)
        addSubview(searchImageView)
        addSubview(searchTextField)
        searchTextField.placeholder = "Поиск"
        
        let imageViews = UIImage.vkc_image(imageName: "icon_search", renderingMode: .alwaysTemplate)
        searchImageView.image = imageViews
    }
    
    override func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? NewsHeaderViewModel else { return }
        avatarImageView.image = viewModel.image
        
        viewModel.updateBlock = { [weak self] in
            guard let `self` = self else { return }
            self.avatarImageView.image = viewModel.image
        }
        
        guard let layoutModel = viewModel.layoutModel as? NewsHeaderLayoutModel else { return }
        avatarImageView.frame = layoutModel.avatarFrame
        searchTextField.frame = layoutModel.searchTextFieldFrame
        searchView.frame = layoutModel.searchFrame
        searchImageView.frame = layoutModel.searchImageFrame
    }
    
    private func configureAppearance() {
        searchImageView.tintColor = AppearanceColor.foggyLabel
        searchImageView.backgroundColor = AppearanceColor.searchBackground
        Appearance.applyFor(searchView: searchView)
        Appearance.applyFor(searchTextField: searchTextField)
    }
}
