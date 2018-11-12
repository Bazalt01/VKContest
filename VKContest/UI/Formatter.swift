//
//  Formatter.swift
//  VKContest
//
//  Created by g.tokmakov on 10/11/2018.
//  Copyright © 2018 g.tokmakov. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    class func vkc_formatted(newsDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: date)
        let index = month.index(month.startIndex, offsetBy: 3)
        
        dateFormatter.dateFormat = "YYYY"
        let year = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        
        var dateString = "\(day) \(month[..<index]) в \(time)"
        if isCurrentYear(date: date) == false {
            dateString = "\(day) \(month[..<index]) \(year)"
        }
        
        return dateString
    }
    
    class private func isCurrentYear(date: Date) -> Bool {
        let today = Date()
        var previousYearComponent = DateComponents()
        previousYearComponent.year = -1
        
        guard let previousYearDate = Calendar.current.date(byAdding: previousYearComponent, to: today) else { return true }
        
        let currentDate = Calendar.current.dateComponents([.year], from: date)
        let previousYear = Calendar.current.dateComponents([.year], from: previousYearDate)
        
        return currentDate.year != previousYear.year
    }
}

extension String {
    static func vkc_formatCounter(counter: Int) -> String {
        guard counter > 1 else { return "" }
        
        var result = String(counter)
        if counter > 999999 {
            result = String(counter / 1000000) + "M"
        } else if counter > 999 {
            result = String(counter / 1000) + "K"
        }
        
        return result
    }
    
    static func vkc_formatCountNews(counter: Int) -> String {
        guard counter > 0 else { return "Нет записей" }
        
        if counter % 10 >= 2 && counter % 10 <= 4 {
            return String(counter) + " записи"
        } else if counter % 10 == 1 {
            return String(counter) + " запись"
        } else {
            return String(counter) + " записей";
        }
    }
}
