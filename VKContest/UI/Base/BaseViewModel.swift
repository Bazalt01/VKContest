//
//  BaseViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class BaseViewModel: Hashable, ViewModel  {
    var viewClass: (UIView & View).Type
    var layoutModel = LayoutModel(frame: CGRect.zero)
    var processID: Int?
    
    required init(viewClass: (UIView & View).Type) {
        self.viewClass = viewClass
    }
    
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func createLayoutModel(fittingFrame frame: CGRect) {}
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return Unmanaged.passUnretained(self).toOpaque().hashValue
    }
    
    func isEqual(viewModel: ViewModel) -> Bool {
        guard viewModel is BaseViewModel else { return false }
        return self == viewModel as! BaseViewModel
    }
    
    func startProcessing() {}
    
    func stopProcessing() {}
}
