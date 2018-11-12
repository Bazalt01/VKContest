//
//  BaseSupplementaryView.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class BaseSupplementaryView: UICollectionReusableView, View {
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    
    func createLayoutModel(fittingFrame frame: CGRect) -> LayoutModel {
        return LayoutModel(frame: frame)
    }
    func apply(viewModel: ViewModel?) {}
}
