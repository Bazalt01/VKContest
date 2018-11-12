//
//  CollectionViewDelegate.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class CollectionViewDelegate: NSObject {    
    private var dataSource: CollectionViewDataSource
    var willDisplayAction: ((_ indexPath: IndexPath) -> ())?
    
    // MARK: - Inits
    
    init(dataSource: CollectionViewDataSource) {
        self.dataSource = dataSource
    }        
}

extension CollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = dataSource.model(atIndexPath: indexPath) else { return }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let action = willDisplayAction else { return }
        action(indexPath)
    }
}

extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard var model = dataSource.model(atIndexPath: indexPath) else { return .zero }        
        return model.layoutModel.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard var viewModel = dataSource.supplementaryViewHeaderModel else { return CGSize.zero }
        return viewModel.layoutModel.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard var viewModel = dataSource.supplementaryViewFooterModel else { return CGSize.zero }
        return viewModel.layoutModel.frame.size
    }
}
