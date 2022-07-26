//
//  Utils.swift
//  SwiftUiDemo
//
//  Created by ADMIN on 2022/4/29.
//

import Foundation

class Utils{
    static func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm:ss"

        return dateFormatter.string(from: dt!)
    }

    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let out = dateFormatter.string(from: dt!)
        return out
    }
    
    static func formatStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        return dateFormatter.string(from: newDate!)
    }
    
    static func timeStampToDate(timeStamp:UInt64, format: String) -> Date {
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date : Date = Date.init(timeIntervalSince1970: timeInterval)
        //let date = NSDate(timeIntervalSince1970: timeInterval)
        return date;
    }
    
    static func timeStampToString(timeStamp:UInt64, format: String) -> String {
            //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            
            //格式话输出
            let dformatter = DateFormatter()
            if format.count <= 0 {
                dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            } else {
                dformatter.dateFormat = format
            }
            return "\(dformatter.string(from: date as Date))"
        }
}
