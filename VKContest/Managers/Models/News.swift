//
//  News.swift
//  VKContest
//
//  Created by g.tokmakov on 09/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

struct News {
    var sourceID: Int64 = 0
    var date = Date()
    var text = ""
    var counters = Counters()
    var photos: [Image] = []
}

struct Counters {
    var comments = 0
    var likes = 0
    var reposts = 0
    var views = 0
}

class NewsParser: Parser {
    typealias Model = News
    
    private static let imageNewsLimits: (min: CGFloat, max: CGFloat) = (320, 500)
    
    // MARK: - Public
    
    static func parse(json: [String : Any]) -> News {
        guard
            var sourceID = json["source_id"] as? Int64,
            let dateValue = json["date"] as? Int32
            else { return News() }
        
        let text = json["text"] as? String ?? ""
        let photos = parsePhotos(json: json)
        let counters = parseCounters(json: json)
        
        let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
        if sourceID < 0 {
            sourceID = sourceID * -1
        }
        return News(sourceID: sourceID, date: date, text: text, counters: counters, photos: photos)
    }
    
    static func isValid(model: News) -> Bool {
        return model.sourceID != 0
    }
    
    // MARK: - Private
    
    private static func parseCounters(json: [String : Any]) -> Counters {
        guard
            let comments = json["comments"] as? [String : Any],
            let likes    = json["likes"] as? [String : Any],
            let reposts  = json["reposts"] as? [String : Any],
            let views    = json["views"] as? [String : Any]
            else { return Counters() }
        return Counters(comments: comments["count"] as? Int ?? 0,
                        likes: likes["count"] as? Int ?? 0,
                        reposts: reposts["count"] as? Int ?? 0,
                        views: views["count"] as? Int ?? 0)
    }
    
    private static func parsePhotos(json: [String : Any]) -> [Image] {
        if let attachments = json["attachments"] as? [[String : Any]] {
            return parsePhotoAttachments(attachments: attachments)
        }
        
        guard
            let photos = json["photos"] as? [String : Any],
            let items = photos["items"] as? [[String : Any]]
            else { return [] }
        return items.compactMap { parsePhoto(json: $0) }
    }
    
    
    private static func parsePhotoAttachments(attachments: [[String : Any]]) -> [Image] {
        var mAtt = attachments
        mAtt = mAtt.filter { attachment -> Bool in
            guard let type = attachment["type"] as? String else { return false }
            return type == "photo"
        }
        
        return mAtt.compactMap { return parsePhoto(json: $0["photo"] as! [String : Any]) }
    }
    
    private static func parsePhoto(json: [String : Any]) -> Image? {
        guard let sizes = json["sizes"] as? [[String : Any]] else { return nil }
        
        var tuples = sizes.map { size -> (size: CGSize, url: String) in
            let width = size["width"] as? Int ?? 0
            let height = size["height"] as? Int ?? 0
            let url = size["url"] as? String ?? ""
            return (CGSize(width: width, height: height), url)
        }
        
        tuples.sort { $0.size.width > $1.size.width}
        let prioritedTuple = tuples.filter { $0.size.width <= imageNewsLimits.max && $0.size.width >= imageNewsLimits.min }
        
        guard let tuple = prioritedTuple.first ?? tuples.first else { return nil }
        return Image(url: tuple.url, size: tuple.size)
    }
}
