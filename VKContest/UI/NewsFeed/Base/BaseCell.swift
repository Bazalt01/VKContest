//
//  BaseCell.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class BaseCell: UICollectionViewCell, View {    
    var viewModel: ViewModel? {
        willSet {
            guard let viewModel = viewModel else { return }
            viewModel.stopProcessing()
        }
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.startProcessing()
            apply(viewModel: viewModel)
        }
    }
    
    func createLayoutModel(fittingFrame frame: CGRect) -> LayoutModel {
        return LayoutModel(frame: frame)
    }
    func apply(viewModel: ViewModel?) {}
}
