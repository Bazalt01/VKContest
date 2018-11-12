//
//  DataBaseService.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

class DataBaseService {
    private var networkService: NetworkService    
    private var queue: OperationQueue
    
    private(set) var groups: [Int64 : Group] = [:]
    private(set) var news: [News] = []
    private(set) var users: [User] = []
    private var startFrom: String?
    private var startTime: Int?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 1
        self.queue.name = "database.service.queue"
    }
    
    func loadLastNews(success: @escaping (_ news: [News]) -> (), failure: @escaping (_ error: Error) -> ()) {
        _ = networkService.loadNews(startFrom: nil, startTime: startTime, success: { (news, groups, nextFrom) in
            self.queue.addOperation { [unowned self] in
                self.process(news: news, inHead: true)
                self.process(groups: groups)
                self.process(startFrom: nextFrom)
                self.process(startTime: Date())
                success(news)
            }
        }, failure: failure)
    }
    
    func loadNews(success: @escaping (_ news: [News]) -> (), failure: @escaping (_ error: Error) -> ()) {
        _ = networkService.loadNews(startFrom: startFrom, startTime: nil, success: { (news, groups, nextFrom) in
            self.queue.addOperation { [unowned self] in
                self.process(news: news, inHead: false)
                self.process(groups: groups)
                self.process(startFrom: nextFrom)
                success(news)
            }
        }, failure: failure)
    }
    
    func loadUsers(success: @escaping (_ users: [User]) -> (), failure: @escaping (_ error: Error) -> ()) {
        _ = networkService.loadUsers(userIDs: [], success: { users in
            self.queue.addOperation { [unowned self] in
                self.users = users
                success(users)
            }
        }, failure: failure)
    }
    
    func process(news: [News], inHead: Bool) {
        if inHead {
            self.news = news + self.news
        } else {
            self.news += news
        }
    }
    
    func process(groups: [Group]) {
        groups.forEach { self.groups[$0.id] = $0 }
    }
    
    func process(startFrom: String?) {
        if self.startFrom == nil {
            process(startTime: Date())
        }
        self.startFrom = startFrom
    }
    
    func process(startTime: Date) {
        self.startTime = Int(startTime.timeIntervalSince1970)
    }
}
