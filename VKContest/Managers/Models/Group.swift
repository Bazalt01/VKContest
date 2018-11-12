//
//  Group.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct Group {
    var id: Int64 = 0
    var name = ""
    var photoURL = ""
}

class GroupParser: Parser {
    typealias Model = Group
    
    // MARK: - Public
    
    static func parse(json: [String : Any]) -> Group {
        guard
            let id = json["id"] as? Int64,
            let name = json["name"] as? String
            else { return Group() }
        
        let photo = json["photo_50"] as? String ?? ""
        return Group(id: id, name: name, photoURL: photo)
    }
    
    static func isValid(model: Group) -> Bool {
        return model.id != 0 && model.name.count > 0
    }
}
