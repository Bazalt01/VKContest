//
//  PhotoView.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class PhotoView: UIView, View {
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    
    private let imageView = UIImageView()

    init() {
        super.init(frame: .zero)
        self.configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {
        addSubview(imageView)
    }
    
    func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? PhotoViewModel else { return }
        frame = viewModel.layoutModel.frame
        imageView.image = viewModel.image
        imageView.frame = bounds
        
        viewModel.updateBlock = { [weak self] in
            guard let `self` = self else { return }
            self.imageView.image = viewModel.image
        }
    }
}
