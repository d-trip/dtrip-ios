//
//  DateDecodingStrategy.swift
//  DTrip
//
//  Created by Artem Semavin on 05/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    public static let formatterSSsssZ: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    public static let formatterSSZ: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    public static let formatterSS: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    public static let formatterSSsss: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    
    enum DateError: String, Error {
        case invalidDate
    }
    
    static var iso8601dtrip: JSONDecoder.DateDecodingStrategy {
        return .custom({ (decoder) throws -> Date in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            
            if let date = formatterSSsssZ.date(from: str) {
                return date
            }
            if let date = formatterSSZ.date(from: str) {
                return date
            }
            if let date = formatterSS.date(from: str) {
                return date
            }
            if let date = formatterSSsss.date(from: str) {
                return date
            }
            
            throw DateError.invalidDate
        })
    }
}
