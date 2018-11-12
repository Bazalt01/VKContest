//
//  PhotoViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class PhotoViewModel: BaseViewModel {
    private var photo: Image
    private(set) var image: UIImage?
    
    var updateBlock: (() -> ())?
    
    init(photo: Image) {
        self.photo = photo
        super.init(viewClass: PhotoView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        let scale = frame.width / photo.originalSize.width
        let size = CGSize(width: frame.width, height: photo.originalSize.height * scale)
        let frame = CGRect(origin: frame.origin, size: size)
        
        layoutModel = LayoutModel(frame: frame)
    }
    
    override func startProcessing() {
        guard image == nil else { return }
        processID = ServiceLocator.shared.imageService.findImageOrLoadIfNeed(url: photo.url, size: layoutModel.frame.size) { [weak self] image in
            guard let `self` = self else { return }
            self.image = image
            self.processID = nil
            guard let updateBlock = self.updateBlock else { return }
            updateBlock()
        }
    }
    
    override func stopProcessing() {
        guard let processID = processID else { return }
        ServiceLocator.shared.imageService.cancelLoadImage(processID: processID)
    }
}
