//
//  NewsCellModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class NewsCellModel: BaseViewModel {
    let groupHeaderViewModel: GroupHeaderViewModel
    let text: String
    let countersViewModel: CountersViewModel
    var attachmentViewModel: ViewModel?
    
    override var layoutModel: LayoutModel {
        didSet {
            guard let lm = layoutModel as? NewsLayoutModel else { return }
            groupHeaderViewModel.layoutModel = lm.groupHeaderLayoutModel
            countersViewModel.layoutModel = lm.countersLayoutModel
            guard let attachmentLayoutModel = lm.attachmentLayoutModel else { return }
            attachmentViewModel?.layoutModel = attachmentLayoutModel
        }
    }
    
    init(newsDTO: NewsDTO, viewClass: (UIView & View).Type) {
        self.text = newsDTO.news.text
        self.groupHeaderViewModel = GroupHeaderViewModel(avatarURL: newsDTO.group.photoURL,
                                                         name: newsDTO.group.name,
                                                         date: DateFormatter.vkc_formatted(newsDate: newsDTO.news.date))
        self.countersViewModel = CountersViewModel(counters: newsDTO.news.counters)
        super.init(viewClass: viewClass)
    }
    
    required init(viewClass: (UIView & View).Type) {
        fatalError("init(viewClass:) has not been implemented")
    }
    
    override func createLayoutModel(fittingFrame frame: CGRect) {
        let externalOffset = AppearanceSize.externalOffset
        let internalOffset = AppearanceSize.internalOffset
        
        var contentFrame = frame
        contentFrame.size.width -= externalOffset * 2
        contentFrame.size.height = externalOffset + (externalOffset / 2.0)
        contentFrame.origin = CGPoint(x: externalOffset, y: externalOffset)
        
        groupHeaderViewModel.createLayoutModel(fittingFrame: contentFrame)
        let glm = groupHeaderViewModel.layoutModel
        guard let groupLayoutModel = glm as? GroupHeaderLayoutModel else {
            layoutModel = LayoutModel(frame: frame)
            return
        }
        
        contentFrame.size.height += groupLayoutModel.frame.height
        
        var textFrame = CGRect(origin: CGPoint(x: 0, y: groupLayoutModel.frame.maxY), size: .zero)
        if text.count > 0 {
            let textOrigin = CGPoint(x: contentFrame.minX, y: groupLayoutModel.frame.maxY + internalOffset)
            textFrame = CGRect(origin: textOrigin, size: CGSize(width: contentFrame.width, height: CGFloat.greatestFiniteMagnitude))
            textFrame = calculated(text: text, frame: textFrame)
            contentFrame.size.height += textFrame.height + internalOffset
        }
        
        var attachmentLayoutModel: LayoutModel?
        if let viewModel = attachmentViewModel {
            
            let attachmentFrame = CGRect(origin: CGPoint(x: 0, y: textFrame.maxY + externalOffset), size: frame.size)
            viewModel.createLayoutModel(fittingFrame: attachmentFrame)
            let layoutModel = viewModel.layoutModel
            
            contentFrame.size.height += layoutModel.frame.height + externalOffset
            attachmentLayoutModel = layoutModel
        }
        
        let countersOffset: CGFloat = externalOffset / 2.0
        var countersY = textFrame.maxY + countersOffset
        if let layoutModel = attachmentLayoutModel {
            countersY = layoutModel.frame.maxY + countersOffset
        }
        let countersFrame = CGRect(origin: CGPoint(x: contentFrame.minX, y: countersY), size: contentFrame.size)
        countersViewModel.createLayoutModel(fittingFrame: countersFrame)
        let clm = countersViewModel.layoutModel
        guard let countersLayoutModel = clm as? CountersLayoutModel else {
            layoutModel = LayoutModel(frame: frame)
            return
        }
        
        contentFrame.size.height += countersLayoutModel.frame.height + countersOffset
        
        let totalSize = CGSize(width: frame.width, height: contentFrame.height)
        let frame = CGRect(origin: .zero, size: totalSize)
        
        layoutModel = NewsLayoutModel(groupHeaderLayoutModel: groupLayoutModel,
                                      textFrame: textFrame,
                                      countersLayoutModel: countersLayoutModel,
                                      attachmentLayoutModel: attachmentLayoutModel,
                                      frame: frame)
    }
    
    private func calculated(text: String, frame: CGRect) -> CGRect {
        let attr = [NSAttributedString.Key.font : AppearanceFont.contentLabel]
        let textAttr = NSAttributedString(string: text, attributes: attr)
        let textHeight = textAttr.boundingRect(with: frame.size, options: fittingOptions, context: nil).size.height
        return CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: textHeight))
    }
    
    override func startProcessing() {
        groupHeaderViewModel.startProcessing()
        attachmentViewModel?.startProcessing()
    }
    
    override func stopProcessing() {
        groupHeaderViewModel.stopProcessing()
        attachmentViewModel?.stopProcessing()
    }
}
