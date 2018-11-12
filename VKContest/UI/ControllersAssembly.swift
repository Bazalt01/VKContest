//
//  ControllersAssembly.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class ControllersAssembly: NSObject {
    weak var rootViewController: UIViewController?
    
    static let shared: ControllersAssembly = {
        return ControllersAssembly()
    }()
    
    // MARK: - Public
    
    func configuredNewsFeedViewController() -> NewsFeedViewController {
        let vm = NewsFeedViewModel(dataBaseService: ServiceLocator.shared.dataBaseService,
                                   imageService: ServiceLocator.shared.imageService,
                                   authService: ServiceLocator.shared.authService)
        return NewsFeedViewController(viewModel: vm)
    }
}

extension ControllersAssembly: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        guard let vc = rootViewController else { return }
        vc.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {        
    }
}
