//
//  ServiceLocator.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class ServiceLocator {
    static let shared: ServiceLocator = {
        return ServiceLocator()
    }()
    
    private let vkInstance = VKSdk.initialize(withAppId: VKConfiguration.appID)
    let authService = AuthService()
    
    private(set) var networkService: NetworkService
    private(set) var dataBaseService: DataBaseService
    private(set) var imageService: ImageService
    
    var vkUIDelegate: VKSdkUIDelegate?
    
    init() {
        self.networkService = NetworkService(authService: self.authService)
        self.dataBaseService = DataBaseService(networkService: self.networkService)
        self.imageService = ImageService(networkService: self.networkService)
    }
    
    // MARK: - Private
    
    func configure() {
        guard let vkInstance = vkInstance else { return }
        vkInstance.register(authService)
        vkInstance.uiDelegate = vkUIDelegate
        authService.configure()
    }
}
