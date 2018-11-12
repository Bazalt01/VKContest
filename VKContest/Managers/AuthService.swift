//
//  AuthService.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol AuthServiceDelegate: AnyObject {
    func didAuthrize()
}

class AuthService: NSObject {
    private(set) var token: VKAccessToken?
    weak var delegate: AuthServiceDelegate?
    
    // MARK: - Public
    
    func configure() {
        VKSdk.wakeUpSession(VKConfiguration.permissions) { [unowned self] (state, error) in
            if state == .authorized {
                self.token = VKSdk.accessToken()
                self.delegate?.didAuthrize()
            } else {
                self.authorize()
            }
        }
    }
    
    // MARK: - Private
    
    private func authorize() {
        VKSdk.authorize(VKConfiguration.permissions)
    }
}

extension AuthService: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        guard let result = result, let token = result.token else { return }
        token.save(toDefaults: VKStorageKeys.accessToken)
        self.token = token
        delegate?.didAuthrize()
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        self.token = nil
        authorize()
    }
}
