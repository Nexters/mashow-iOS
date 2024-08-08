//
//  Environment.swift
//  Mashow
//
//  Created by Kai Lee on 7/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Moya
import Willow

struct Environment {
    private static let internalNetwork = NetworkManager(
        provider: MoyaProvider<API>(plugins: [
            // Logger
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]))
    static var network: NetworkManager<API> {
        internalNetwork
    }
    
    private static let internalStorage = StorageManager()
    static var storage: StorageManager {
        internalStorage
    }
    
    private static let internalLogger = Logger(logLevels: .all, writers: [OSLogWriter(subsystem: "Mashow", category: "Mashow Logger")])
    static var logger: Logger {
        internalLogger
    }
}
