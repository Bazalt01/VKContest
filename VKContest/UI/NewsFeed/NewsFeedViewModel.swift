//
//  NewsFeedViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

private let limitForPreload = 20

protocol NewsFeedViewModelDelegate: AnyObject {
    func didStartLoadContent(sender: NewsFeedViewModel)
    func didFinishLoadContent(sender: NewsFeedViewModel)
}

class NewsFeedViewModel {
    private var dataBaseService: DataBaseService
    private var imageService: ImageService
    private var authService: AuthService
    
    weak var delegate: NewsFeedViewModelDelegate?
        
    private(set) var dataSource: NewsFeedDataSource
    private(set) var collectionDelegate: CollectionViewDelegate
    
    private var isLoading = false {
        didSet {
            guard let delegate = delegate else { return }
            if isLoading {
                delegate.didStartLoadContent(sender: self)
            } else {
                delegate.didFinishLoadContent(sender: self)
            }
        }
    }
    
    init(dataBaseService: DataBaseService, imageService: ImageService, authService: AuthService) {
        self.dataBaseService = dataBaseService
        self.imageService = imageService
        self.authService = authService
        self.dataSource = NewsFeedDataSource()
        self.collectionDelegate = CollectionViewDelegate(dataSource: self.dataSource)
    }
    
    func configure() {
        dataSource.configure()
        guard let _ = authService.token else {
            authService.delegate = self
            return
        }
        _configure()
    }
    
    private func _configure() {
        collectionDelegate.willDisplayAction = { [unowned self] indexPath in
            guard self.needLoadMore(indexPath: indexPath) else { return }
            self.loadContent()
        }
        loadContent()
        loadUserAccount()
    }
    
    func loadNewContent() {
        isLoading = true
        dataBaseService.loadLastNews(success: { [unowned self] news in
            let newsDTOs = self.configuredNewsDTO(newsList: news)
            DispatchQueue.main.async {
                self.isLoading = false
                self.dataSource.insert(at: 0, newsDTOs: newsDTOs)
            }
        }) { [unowned self] error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func loadUserAccount() {
        dataBaseService.loadUsers(success: { [unowned self] users in
            DispatchQueue.main.async {
                guard let user = users.first else { return }
                self.dataSource.updateHeader(photo: user.photo)
            }
        }) { error in
        }
    }
    
    private func loadContent() {
        isLoading = true
        dataBaseService.loadNews(success: { [unowned self] news in
            let newsDTOs = self.configuredNewsDTO(newsList: news)
            DispatchQueue.main.async {
                self.isLoading = false
                self.dataSource.add(newsDTOs: newsDTOs)
            }
        }) { [unowned self] error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func needLoadMore(indexPath: IndexPath) -> Bool {
        guard isLoading == false else { return false }
        let rest = dataSource.cellViewModels.count - indexPath.item
        return limitForPreload > rest
    }
    
    func configuredNewsDTO(newsList: [News]) -> [NewsDTO] {
        let groups = self.dataBaseService.groups
        return newsList
            .map { news -> NewsDTO? in
                guard let group = groups[news.sourceID] else { return nil }
                return NewsDTO(news: news, group: group)
            }
            .filter { $0 != nil } as! [NewsDTO]
    }
}

extension NewsFeedViewModel: AuthServiceDelegate {
    func didAuthrize() {
        _configure()
    }
}
