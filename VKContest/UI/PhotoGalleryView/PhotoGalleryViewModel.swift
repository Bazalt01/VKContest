//
//  PhotoGalleryViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class PhotoGalleryViewModel: BaseViewModel {
    private var photos: [Image]
    private var loadedImage: [String : UIImage] = [:]
    private var processIDs: [String : Int] = [:]
    
    var currentIndex = 0
    var pendingIndex = 0
    
    var photoCount: Int {
        return photos.count
    }
    
    var updateBlock: (() -> ())?
    
    init(photos: [Image]) {
        self.photos = photos
        super.init(viewClass: PhotoView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    // MARK: - Public
    
    func image(index: Int) -> UIImage? {
        let photo = photos[index]
        return loadedImage[photo.url]
    }
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        var mFrame = frame
        mFrame.size.height = AppearanceSize.photoGalleryHeight
        layoutModel = LayoutModel(frame: mFrame)
    }
    
    override func startProcessing() {
        for photo in photos {
            guard loadedImage[photo.url] == nil else { continue }
            
            processIDs[photo.url] = ServiceLocator.shared.imageService.findImageOrLoadIfNeed(url: photo.url, size: photo.originalSize) { [weak self] image in
                guard let `self` = self else { return }
                self.loadedImage[photo.url] = image
                self.processIDs[photo.url] = nil
                guard let updateBlock = self.updateBlock else { return }
                updateBlock()
            }
        }
    }
    
    override func stopProcessing() {
        guard processIDs.count > 0 else { return }
        processIDs.forEach { ServiceLocator.shared.imageService.cancelLoadImage(processID: $0.value) }
    }
}
