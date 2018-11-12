//
//  GroupHeaderModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class GroupHeaderViewModel: BaseViewModel {
    private(set) var avatar: UIImage?
    private(set) var name: String
    private(set) var date: String
    private var avatarURL: String
    
    var updateBlock: (() -> ())?
    
    init(avatarURL: String, name: String, date: String) {
        self.avatarURL = avatarURL
        self.name = name
        self.date = date
        super.init(viewClass: GroupHeaderView.self)
    }
    
    @available(*, unavailable)
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    // MARK: - Public
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        let avatarFrame = CGRect(origin: .zero, size: AppearanceSize.avatarSize)
        
        let nameWidth = frame.width - AppearanceSize.internalOffset - avatarFrame.width
        let nameHeight: CGFloat = 17
        let nameOrigin = CGPoint(x: avatarFrame.maxX + AppearanceSize.internalOffset, y: 2)
        let nameFrame = CGRect(origin: nameOrigin, size: CGSize(width: nameWidth, height: nameHeight))
        
        let dateWidth = nameWidth
        let dateHeight: CGFloat = 15
        let dateOrigin = CGPoint(x: nameOrigin.x, y: nameFrame.maxY)
        let dateFrame = CGRect(origin: dateOrigin, size: CGSize(width: dateWidth, height: dateHeight))
        
        let totalSize = CGSize(width: frame.width, height: avatarFrame.height)
        let frame = CGRect(origin: frame.origin, size: totalSize)
        
        layoutModel =  GroupHeaderLayoutModel(avatarFrame: avatarFrame, nameFrame: nameFrame, dateFrame: dateFrame, frame: frame)
    }
    
    override func startProcessing() {
        guard avatar == nil else { return }
        processID = ServiceLocator.shared.imageService.findAvatarOrLoadIfNeed(url: avatarURL, size: AppearanceSize.avatarSize) { [weak self] image in
            guard let `self` = self else { return }
            self.avatar = image
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
