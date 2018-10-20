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
        // ToDo: - make handle error func
	}
}
