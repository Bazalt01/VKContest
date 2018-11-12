//
//  LayoutService.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

typealias viewClass = String

class LayoutService {
    private var queue: OperationQueue
    private var waitedViewModels: [ViewModel] = []
    weak var collectionView: UICollectionView?
    
    init() {        
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
        self.queue.name = "collection.view.delegate.queue"
    }
    
    func layoutIsReady() {
        let models = self.waitedViewModels
        self.calculateLayoutModels(viewModels: models, completion: {})
        self.waitedViewModels = []
    }
    
    func calculateLayoutModels(viewModels: [ViewModel], completion: @escaping () -> ()) {
        guard let collectionView = collectionView else { return }
        let size = maxVisibleContentSize(collectionView: collectionView)
        
        self.queue.addOperation { [unowned self] in
            guard size.width > 0 && size.height > 0 else {
                self.waitedViewModels += viewModels
                completion()
                return
            }
            
            viewModels.forEach { $0.createLayoutModel(fittingFrame: CGRect(origin: .zero, size: size)) }
            completion()
        }
    }
    
    // MARK: - Private
    
    private func maxVisibleContentSize(collectionView: UICollectionView) -> CGSize {
        var size = collectionView.bounds.size
        let contentInset = collectionView.contentInset
        size.width -= contentInset.left + contentInset.right
        size.height -= contentInset.top + contentInset.bottom
        return size
    }
}
