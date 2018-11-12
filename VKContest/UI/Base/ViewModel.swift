//
//  ViewModel.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

protocol ViewModel {
    var viewClass: (UIView & View).Type { get }
    var layoutModel: LayoutModel { get set }
    var processID: Int? { get set }
    
    // MARK: - Inits
    
    init(viewClass: (UIView & View).Type)
    
    func isEqual(viewModel: ViewModel) -> Bool
    func createLayoutModel(fittingFrame frame: CGRect)
    func startProcessing()
    func stopProcessing()
}
