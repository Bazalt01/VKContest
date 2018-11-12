//
//  CountersView.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class CountersView: UIView, View {
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    
    private let likesButton = UIButton()
    private let likesLabel = UILabel()
    private let commentsButton = UIButton()
    private let commentsLabel = UILabel()
    private let repostsButton = UIButton()
    private let repostsLabel = UILabel()
    private let viewsImageView = UIImageView()
    private let viewsLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        self.configureViews()
        self.configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(likesButton)
        addSubview(likesLabel)
        addSubview(commentsButton)
        addSubview(commentsLabel)
        addSubview(repostsButton)
        addSubview(repostsLabel)
        addSubview(viewsImageView)
        addSubview(viewsLabel)
        
        let imageLike = UIImage.vkc_image(imageName: "icon_like", renderingMode: .alwaysTemplate)
        likesButton.setImage(imageLike, for: .normal)
        
        let imageComment = UIImage.vkc_image(imageName: "icon_comment", renderingMode: .alwaysTemplate)
        commentsButton.setImage(imageComment, for: .normal)
        
        let imageRepost = UIImage.vkc_image(imageName: "icon_share", renderingMode: .alwaysTemplate)
        repostsButton.setImage(imageRepost, for: .normal)
        
        let imageViews = UIImage.vkc_image(imageName: "icon_view", renderingMode: .alwaysTemplate)
        viewsImageView.image = imageViews
        viewsImageView.contentMode = .center
    }
    
    func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? CountersViewModel else { return }
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        repostsLabel.text = viewModel.reposts
        viewsLabel.text = viewModel.views
        
        frame = viewModel.layoutModel.frame
        
        guard let layoutModel = viewModel.layoutModel as? CountersLayoutModel else { return }
        likesButton.frame = layoutModel.likes.button
        likesLabel.frame = layoutModel.likes.label
        commentsButton.frame = layoutModel.comments.button
        commentsLabel.frame = layoutModel.comments.label
        repostsButton.frame = layoutModel.reposts.button
        repostsLabel.frame = layoutModel.reposts.label
        viewsImageView.frame = layoutModel.views.button
        viewsLabel.frame = layoutModel.views.label
    }
    
    private func configureAppearance() {
        Appearance.applyFor(activeCounterLabel: likesLabel)
        Appearance.applyFor(activeCounterLabel: commentsLabel)
        Appearance.applyFor(activeCounterLabel: repostsLabel)
        
        Appearance.applyFor(activeCounterButton: likesButton)
        Appearance.applyFor(activeCounterButton: commentsButton)
        Appearance.applyFor(activeCounterButton: repostsButton)
        
        Appearance.applyFor(inactiveCounterLabel: viewsLabel)
        viewsImageView.tintColor = AppearanceColor.inactiveCounter
    }
}
