//
//  CollectionViewDataSource.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

enum BatchOption: UInt {
    case delete
    case insert
    case update
}

struct BatchUpdate {
    private(set) var option: BatchOption
    private(set) var indexPathes: [IndexPath]
    private(set) var sections: IndexSet
    init(option: BatchOption, indexPathes: [IndexPath], sections: IndexSet) {
        self.option = option
        self.indexPathes = indexPathes
        self.sections = sections
    }
}

class CollectionViewDataSource: NSObject {
    var cellViewModels: [ViewModel] = []
    var supplementaryViewFooterModel: ViewModel?
    var supplementaryViewHeaderModel: ViewModel?
    
    weak var collectionView: UICollectionView? {
        didSet {
            guard let collectionView = collectionView else { return }
            register(collectionView: collectionView)
        }
    }
    
    func register(collectionView: UICollectionView) {}
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func model(atIndexPath indexPath: IndexPath) -> ViewModel? {
        assert(cellViewModels.count > 0)
        return cellViewModels[indexPath.item]
    }
    
    func notify(batchUpdates: [BatchUpdate]?, update: () -> (), completion: (() -> ())?) {
        guard
            let cv = collectionView,
            let batchUpdates = batchUpdates else {
                notifyUpdate()
                return
        }
        cv.performBatchUpdates({
            update()
            self.performBatchUpdates(collectionView: cv, batchUpdates: batchUpdates)
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Private
    
    func notifyUpdate() {
        guard let cv = collectionView else { return }
        cv.reloadData()
    }
    
    private func performBatchUpdates(collectionView: UICollectionView, batchUpdates: [BatchUpdate]) {
        let sortedBatchUpdates = batchUpdates.sorted { $0.option.rawValue < $1.option.rawValue }
        for batch in sortedBatchUpdates {
            switch batch.option {
            case .delete:
                collectionView.deleteItems(at: batch.indexPathes)
                collectionView.deleteSections(batch.sections)
                break
            case .insert:
                collectionView.insertSections(batch.sections)
                collectionView.insertItems(at: batch.indexPathes)
                break
            case .update:
                collectionView.reloadItems(at: batch.indexPathes)
            }
        }
    }
}

extension CollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = model(atIndexPath: indexPath) else { return UICollectionViewCell() }
        let reuseIdentifier = cellViewModel.viewClass.ca_reuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseCell
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var viewModel: ViewModel?
        if kind == UICollectionView.elementKindSectionFooter {
            viewModel = supplementaryViewFooterModel
        } else if kind == UICollectionView.elementKindSectionHeader {
            viewModel = supplementaryViewHeaderModel
        }
        guard let vm = viewModel else { return UICollectionReusableView() }        
        let reuseIdentifier = vm.viewClass.ca_reuseIdentifier()
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as! BaseSupplementaryView
        view.viewModel = vm
        return view
    }
}
