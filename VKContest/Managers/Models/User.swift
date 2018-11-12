//
//  User.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct User {
    var sourseID: Int64
    var nickname: String
    var photo: Image
}

class UserParser: Parser {
    typealias Model = User
    
    // MARK: - Public
    
    static func parse(json: [String : Any]) -> User {
        guard
            let id = json["id"] as? Int64,
            let firstname = json["first_name"] as? String,
            let lastname = json["last_name"] as? String
            else {
                return User(sourseID: 0, nickname: "", photo: Image(url: "", size: .zero))
        }
        
        var nickname = firstname.count > 0 ? firstname : lastname
        if firstname.count > 0 && lastname.count > 0 {
            nickname = firstname + " " + lastname
        }
        
        let photoURL = json["photo_50"] as? String ?? ""        
        let photo = Image(url: photoURL, size: CGSize(width: 50, height: 50))
        return User(sourseID: id, nickname: nickname, photo: photo)
    }
    
    static func isValid(model: User) -> Bool {
        return model.sourseID != 0 && model.nickname.count > 0
    }
}
