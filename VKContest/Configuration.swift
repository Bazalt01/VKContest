//
//  Configuration.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct VKConfiguration {
    static let appID = "6746396"
    static let permissions = ["wall", "friends"]
    static let server = "VKContest"
}

struct VKStorageKeys {
    static let accessToken = "vk_access_token"
    static let nickname = "nickname"
    static let avatarURL = "avatar_url"
}

struct VKImageStoragePaths {
    static let news = "news"
    static let groups = "groups"
    static let users = "users"
}
