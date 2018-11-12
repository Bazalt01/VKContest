//
//  PhotoGalleryView.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

class PhotoGalleryView: UIView, View {
    private var pageViewController: UIPageViewController
    var viewModel: ViewModel? {
        didSet {
            apply(viewModel: viewModel)
        }
    }
    var photoPagesVC: [PhotoViewController] = []
    
    init() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(frame: .zero)
        self.configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureViews() {        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        Appearance.configurePageControl()
        
        addSubview(pageViewController.view)
    }
    
    func apply(viewModel: ViewModel?) {
        guard let viewModel = viewModel as? PhotoGalleryViewModel else { return }
        frame = viewModel.layoutModel.frame
        pageViewController.view.frame = bounds
        
        while photoPagesVC.count < viewModel.photoCount {
            photoPagesVC.append(PhotoViewController())
        }
        
        for index in 0..<viewModel.photoCount {
            photoPagesVC[index].imageView.image = viewModel.image(index: index)
        }
        
        pageViewController.setViewControllers([photoPagesVC.first!], direction: .forward, animated: true, completion: nil)
        
        viewModel.updateBlock = { [weak self] in
            guard let `self` = self else { return }
            for index in 0..<viewModel.photoCount {
                self.photoPagesVC[index].imageView.image = viewModel.image(index: index)
            }
        }
    }
}

extension PhotoGalleryView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            let viewModel = viewModel as? PhotoGalleryViewModel,
            let index = photoPagesVC.firstIndex(of: pendingViewControllers.first! as! PhotoViewController)
            else { return }
        viewModel.pendingIndex = index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, let viewModel = viewModel as? PhotoGalleryViewModel else { return }
        viewModel.currentIndex = viewModel.pendingIndex
    }
}

extension PhotoGalleryView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let viewModel = viewModel as? PhotoGalleryViewModel,
            let index = photoPagesVC.firstIndex(of: viewController as! PhotoViewController),
            index > 0
            else { return nil }
        let previousIndex = index - 1
        let vc = photoPagesVC[previousIndex]
        vc.imageView.image = viewModel.image(index: previousIndex)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let viewModel = viewModel as? PhotoGalleryViewModel,
            let index = photoPagesVC.firstIndex(of: viewController as! PhotoViewController),
            index < viewModel.photoCount - 1
            else { return nil }
        let nextIndex = index + 1
        let vc = photoPagesVC[nextIndex]
        vc.imageView.image = viewModel.image(index: nextIndex)
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard let viewModel = viewModel as? PhotoGalleryViewModel else { return 0 }
        return viewModel.photoCount
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewModel = viewModel as? PhotoGalleryViewModel else { return 0 }
        return viewModel.currentIndex
    }
}
