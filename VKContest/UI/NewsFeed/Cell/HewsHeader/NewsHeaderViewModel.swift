//
//  NewsHeaderViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 11/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class NewsHeaderViewModel: BaseViewModel {
    var avatar: Image?
    private(set) var image: UIImage?
    
    var updateBlock: (() -> ())?
    
    init() {        
        super.init(viewClass: NewsHeaderView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        
        let offset = AppearanceSize.externalOffset - AppearanceSize.inset
        let avatarSize = AppearanceSize.avatarSize
        let avatarOrigin = CGPoint(x: frame.width - offset - avatarSize.width, y: AppearanceSize.externalOffset)
        let avatarFrame = CGRect(origin: avatarOrigin, size: AppearanceSize.avatarSize)
        
        let searchWidth = frame.width - avatarFrame.width - AppearanceSize.externalOffset - offset * 2
        let searchSize = CGSize(width: searchWidth, height: avatarSize.height)
        let searchFrame = CGRect(origin: CGPoint(x: offset, y: AppearanceSize.externalOffset), size: searchSize)
        
        let searchImageSize = CGSize(width: 14, height: 14)
        let searchImageOrigin = CGPoint(x: searchFrame.minX + 13, y: searchFrame.midY - searchImageSize.height / 2)
        let searchImageFrame = CGRect(origin: searchImageOrigin, size: searchImageSize)

        let searchTextFieldOrigin = CGPoint(x: searchImageFrame.maxX + AppearanceSize.inset, y: searchFrame.minY)
        let searchTextFieldWidth = searchFrame.width - searchImageFrame.maxX - AppearanceSize.inset - AppearanceSize.externalOffset
        let searchTextFieldSize = CGSize(width: searchTextFieldWidth, height: avatarSize.height)
        let searchTextFieldFrame = CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize)
                
        let frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: AppearanceSize.avatarSize.height + AppearanceSize.externalOffset * 2))
        
        layoutModel = NewsHeaderLayoutModel(searchFrame: searchFrame, searchImageFrame: searchImageFrame, searchTextFieldFrame: searchTextFieldFrame, avatarFrame: avatarFrame, frame: frame)
    }
    
    override func startProcessing() {
        guard
            image == nil,
            let avatar = avatar
            else { return }
        processID = ServiceLocator.shared.imageService.findAvatarOrLoadIfNeed(url: avatar.url, size: AppearanceSize.avatarSize) { [weak self] image in
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
