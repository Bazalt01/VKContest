//
//  NewsFeedViewController.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    private var viewModel: NewsFeedViewModel
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var refreshControl = UIRefreshControl()
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionLayout()
        viewModel.dataSource.layoutService.layoutIsReady()
    }
    
    private func configure() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        viewModel.delegate = self
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(sender:)), for: .valueChanged)
        
        collectionView.dataSource = viewModel.dataSource
        viewModel.dataSource.collectionView = collectionView        
        collectionView.delegate = viewModel.collectionDelegate
        
        configureAppearance()
    }
    
    @objc private func handleRefresh(sender: UIRefreshControl) {
        viewModel.loadNewContent()
    }
    
    private func configureCollectionLayout() {
        collectionView.frame = view.bounds
        var contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            contentInset = view.safeAreaInsets
        } else {
            contentInset.bottom = AppearanceSize.inset
        }
        contentInset.right = AppearanceSize.inset
        contentInset.left = AppearanceSize.inset
        collectionView.contentInset = contentInset
    }
    
    private func configureAppearance() {
        Appearance.applyFor(newsFeedView: view)
        collectionView.backgroundColor = .clear
    }
}

extension NewsFeedViewController: NewsFeedViewModelDelegate {
    func didStartLoadContent(sender: NewsFeedViewModel) {
        
    }
    
    func didFinishLoadContent(sender: NewsFeedViewModel) {
        guard refreshControl.isRefreshing else { return }
        refreshControl.endRefreshing()
    }
}
