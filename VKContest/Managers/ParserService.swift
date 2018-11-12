//
//  ParserService.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

protocol Parser {
    associatedtype Model
    static func parse(json: [String : Any]) -> Model
    static func isValid(model: Model) -> Bool
}

class ParserService {
    class func parseUsers(jsons: [[String : Any]]) -> [User] {
        return jsons
            .map { UserParser.parse(json: $0) }
            .filter { UserParser.isValid(model: $0) }
    }
    
    class func parseGroups(json: [String : Any]) -> [Group] {
        guard let groups = json["groups"] as? [[String : Any]] else { return [] }
        return groups
            .map { GroupParser.parse(json: $0) }
            .filter { GroupParser.isValid(model: $0) }
    }
    
    class func parseNews(json: [String : Any]) -> [News] {
        guard let items = json["items"] as? [[String : Any]] else { return [] }
        return items
            .map { NewsParser.parse(json: $0) }
            .filter { NewsParser.isValid(model: $0) }
    }
}
