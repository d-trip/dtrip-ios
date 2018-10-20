//
//  LogManager.swift
//  DTrip
//
//  Created by Artem Semavin on 19/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
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
