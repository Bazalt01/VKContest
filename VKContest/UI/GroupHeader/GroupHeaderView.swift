//
//  GroupHeaderView.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class GroupHeaderView: UIView, View {
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    
    private let avatarImage = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    
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
        addSubview(avatarImage)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
    
    func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? GroupHeaderViewModel else { return }
        avatarImage.image = viewModel.avatar
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        
        viewModel.updateBlock = { [weak self] in
            guard let `self` = self else { return }
            self.avatarImage.image = viewModel.avatar
        }
        
        frame = viewModel.layoutModel.frame
        
        guard let layoutModel = viewModel.layoutModel as? GroupHeaderLayoutModel else { return }
        avatarImage.frame = layoutModel.avatarFrame
        nameLabel.frame = layoutModel.nameFrame
        dateLabel.frame = layoutModel.dateFrame
    }
    
    private func configureAppearance() {
        Appearance.applyFor(nameLabel: nameLabel)
        Appearance.applyFor(dateLabel: dateLabel)
    }
}
