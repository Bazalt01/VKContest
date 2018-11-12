//
//  NetworkService.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

private let vkURLString = "https://api.vk.com/method"

private struct VKMethods {
    static let users = "users.get"
    static let newsFeed = "newsfeed.get"
    static let newsFeedSearch = "newsfeed.search"
}

typealias SuccesseNewsClosure = (_ news: [News], _ group: [Group], _ nextFrom: String?) -> ()
typealias FailureClosure = (_ error: Error) -> ()

class NetworkService {
    private var taskIncrement = 0
    private var taskMap = NSMapTable<NSNumber, URLSessionTask>.strongToWeakObjects()
    private var authService: AuthService
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)    
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Public
    
    func loadUsers(userIDs: [String], success: @escaping (_ users: [User]) -> (), failure: @escaping FailureClosure) -> Int {
        var parameters: [String : Any] = ["fields" : "photo_50"]
        if userIDs.count > 0 {
            parameters["user_ids"] = userIDs
        }
        guard let request = configuredRequest(method: VKMethods.users, parameters: parameters) else {
            failure(VKContestError.failedRequest)
            return Int.max
        }
        return performRequest(request: request, success: { [unowned self] data in
            let responceJson = self.json(fromData: data)
            let jsons = responceJson["response"] as? [[String: Any]] ?? [[:]]
            success(ParserService.parseUsers(jsons: jsons))
        }, failure: failure)
    }

    func loadNews(startFrom: String?, startTime: Int?, success: @escaping SuccesseNewsClosure, failure: @escaping FailureClosure) -> Int {
        let filterValues = ["post","photo","photo_tag", "wall_photo"]
        var parameters: [String : Any] = ["filters" : filterValues,
                                          "count" : 40]
        if let startFrom = startFrom {
            parameters["start_from"] = startFrom
        }
        if let startTime = startTime {
            parameters["start_time"] = startTime
        }
        
        guard let request = configuredRequest(method: VKMethods.newsFeed, parameters: parameters) else {
            failure(VKContestError.failedRequest)
            return Int.max
        }
        
        return performRequest(request: request, success: { [unowned self] data in
            let responceJson = self.json(fromData: data)
            let json = responceJson["response"] as? [String: Any] ?? [:]
            success(ParserService.parseNews(json: json), ParserService.parseGroups(json: json), json["next_from"] as? String)
        }, failure: failure)
    }
    
    func downloadFile(urlString: String, success: @escaping (_ data: Data) -> (), failure: @escaping FailureClosure) -> Int {
        guard let url = URL(string: urlString) else {
            failure(VKContestError.failedRequest)
            return Int.max
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        return performRequest(request: request, success: success, failure: failure)
    }
    
    func cancel(taskID: Int) {
        guard let task = taskMap.object(forKey: NSNumber(integerLiteral: taskIncrement)) else { return }
        task.cancel()
    }
    
    // MARK: - Private
    
    private func configuredRequest(method: String, parameters: [String : Any]) -> URLRequest? {
        guard let token = authService.token?.accessToken else { return nil }

        var parameters = parameters
        parameters["access_token"] = token
        parameters["v"] = "5.87"

        guard let url = configuredURL(method: method, parameters: parameters) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        return request
    }

    private func configuredURL(method: String, parameters: [String : Any]) -> URL? {
        var urlString = vkURLString + "/" + method
        if parameters.count > 0 {
            urlString += "?"
        }
        let valueByKey = parameters.map { (key, value) -> String in
            if let param = value as? String {
                return key + "=" + param
            } else if let param = value as? Int {
                return key + "=" + String(param)
            } else if let param = value as? [String] {
                return key + "=" + param.joined(separator: ",")
            }
            return ""
        }
        urlString += valueByKey.joined(separator: "&")
        return URL(string: urlString)
    }
    
    private func json(fromData data: Data?) -> [String : Any] {
        guard
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let responceJson = json as? [String: Any]
            else { return [:]}
        return responceJson
    }

    private func performRequest(request: URLRequest, success: @escaping (_ success: Data) -> (), failure: @escaping FailureClosure) -> Int {
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
                return
            }
            success(data ?? Data())
        }
        task.resume()
        return add(task: task)
    }
    
    private func add(task: URLSessionTask) -> Int {
        taskIncrement += 1
        taskMap.setObject(task, forKey: NSNumber(integerLiteral: taskIncrement))
        return taskIncrement
    }
}
