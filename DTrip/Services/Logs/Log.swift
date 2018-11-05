//
//  Log.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Log {
    static func info(_ format: String, _ args: CVarArg...) {
        DDLogInfo(String(format: format, args))
    }

    static func warning(_ format: String, _ args: CVarArg...) {
        DDLogWarn(String(format: format, args))
    }

    static func error(_ format: String, _ args: CVarArg...) {
        DDLogError(String(format: format, args))
    }

    static func debug(_ format: String, _ args: CVarArg...) {
        DDLogDebug(String(format: format, args))
    }

	static func handleError(_ error: Error, showError: Bool = false) {
        
        var errorMessage = ""
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .dataCorrupted(let context):
                DDLogError("""
                    Decode error: \(context.debugDescription)
                    Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
                    """)
                
                errorMessage = "Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))"
            case .keyNotFound(let codingkey, let context):
                DDLogError("""
                    Decode error: \(context.debugDescription)
                    Coding key: \(codingkey.stringValue)
                    Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
                    """)
                
                errorMessage = "Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))"
            case .typeMismatch(let type, let context):
                DDLogError("""
                    Decode error: \(context.debugDescription)
                    Type: \(type) Extra: \(context.codingPath.debugDescription) Extra2: \(context.underlyingError.debugDescription)
                    Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
                    """)
                
                errorMessage = "Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))"
            case .valueNotFound(let type, let context):
                DDLogError("""
                    Decode error: \(context.debugDescription)
                    Type: \(type) Extra: \(context.codingPath.debugDescription) Extra2: \(context.underlyingError.debugDescription)
                    Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))
                    """)
                
                errorMessage = "Coding path: \(context.codingPath.compactMap({ $0.stringValue }).joined(separator: " -> "))"
            }
        } else {
            DDLogError(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        if showError {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(settingsAction)
            
            var presented = UIApplication.shared.keyWindow?.rootViewController
            while (presented?.presentedViewController as? UINavigationController != nil) {
                presented = presented?.presentedViewController
            }
            presented?.present(alertController, animated: true, completion: nil)
        }
	}
}
