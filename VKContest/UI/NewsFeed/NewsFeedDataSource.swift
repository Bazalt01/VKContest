//
//  NewsFeedDataSource.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct NewsDTO {
    var news: News
    var group: Group
}

class NewsFeedDataSource: CollectionViewDataSource {
    private var header = NewsHeaderViewModel()
    private let footer = NewsFooterViewModel()
    let layoutService = LayoutService()
    
    override init() {
        super.init()
        self.supplementaryViewHeaderModel = header
        self.supplementaryViewFooterModel = footer
    }
    
    override var collectionView: UICollectionView? {
        didSet {
            layoutService.collectionView = collectionView
        }
    }
    
    func configure() {
        layoutService.calculateLayoutModels(viewModels: [footer, header]) {}
    }
    
    func updateHeader(photo: Image) {
        header.avatar = photo
        header.startProcessing()
    }
    
    func add(newsDTOs: [NewsDTO]) {
        insert(at: cellViewModels.count, newsDTOs: newsDTOs)
    }
    
    func insert(at index: Int, newsDTOs: [NewsDTO]) {
        guard newsDTOs.count > 0 else { return }
        
        var indexPaths: [IndexPath] = []
        let viewModels = newsDTOs.map { newsDTO -> ViewModel in
            let newIndex = index + indexPaths.count
            indexPaths.append(IndexPath(item: newIndex, section: 0))
            return configuredViewModel(newsDTO: newsDTO)
        }
        
        layoutService.calculateLayoutModels(viewModels: viewModels) { [unowned self] in
            DispatchQueue.main.async {
                let batchUpdate = BatchUpdate(option: .insert, indexPathes: indexPaths, sections: IndexSet([]))
                self.notify(batchUpdates: [batchUpdate], update: {
                    self.cellViewModels.insert(contentsOf: viewModels, at: index)
                }, completion: nil)
                
                self.footer.counter = self.cellViewModels.count
            }
        }
    }
    
    override func register(collectionView: UICollectionView) {
        let cellClasses = [NewsCell.self, NewsCellWithPhoto.self, NewsCellWithPhotoGallery.self]
        cellClasses.forEach { collectionView.register($0, forCellWithReuseIdentifier: $0.ca_reuseIdentifier()) }
        
        collectionView.register(NewsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NewsFooterView.ca_reuseIdentifier())
        collectionView.register(NewsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewsHeaderView.ca_reuseIdentifier())
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    private func configuredViewModel(newsDTO: NewsDTO) -> ViewModel {
        if newsDTO.news.photos.count > 1 {
            let viewModel = NewsCellModel(newsDTO: newsDTO, viewClass: NewsCellWithPhotoGallery.self)
            let galleryViewModel = PhotoGalleryViewModel(photos: newsDTO.news.photos)
            viewModel.attachmentViewModel = galleryViewModel
            return viewModel
        }
        
        if newsDTO.news.photos.count == 1 {
            let viewModel = NewsCellModel(newsDTO: newsDTO, viewClass: NewsCellWithPhoto.self)
            let galleryViewModel = PhotoViewModel(photo: newsDTO.news.photos.first!)
            viewModel.attachmentViewModel = galleryViewModel
            return viewModel
        }
        
        return NewsCellModel(newsDTO: newsDTO, viewClass: NewsCell.self)
    }
}
