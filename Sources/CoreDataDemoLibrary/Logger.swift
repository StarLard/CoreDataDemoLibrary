//
//  Logger.swift
//  CoreDataDemoLibrary
//
//  Created by Caleb Friden on 9/15/20.
//

import os.log

extension Logger {
    private static let subsytem = "core-data-demo-library"
    
    static let dataStore = Logger(subsystem: subsytem, category: "data-store")
    static let models = Logger(subsystem: subsytem, category: "models")
}
