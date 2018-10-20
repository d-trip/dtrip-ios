//
//  LogManager.swift
//  MusicApp
//
//  Created by Artem Semavin on 25/07/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LogManager {
    static let shared = LogManager()

    init() {

		#if DEBUG
			defaultDebugLevel = .all
			
			DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
			DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
		#else
			defaultDebugLevel = .error
		#endif
    }
}
