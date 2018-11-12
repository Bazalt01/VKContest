//
//  View.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import UIKit

protocol View {
    var viewModel: ViewModel? { get set }
    func apply(viewModel: ViewModel?)    
}

extension UIView {
    
    // MARK: - Public
    
    class func ca_reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }
}
