//
//  ConfigManager.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import Foundation

class ConfigManager {
    static let shared = ConfigManager()

    private let config: [String: Any]

    private init() {
        let environment = ProcessInfo.processInfo.arguments
            .drop(while: { $0 != "-Environment" })
            .dropFirst()
            .first ?? "Development"

        let plistFileName = environment == "Staging" ? "Configuration-Staging" : "Configuration"

        guard let path = Bundle.main.path(forResource: plistFileName, ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Missing \(plistFileName).plist file")
        }

        self.config = dictionary
    }

    func getValue<T>(forKey key: String, defaultValue: T) -> T {
        return config[key] as? T ?? defaultValue
    }

    var apiBaseURL: String {
        return getValue(forKey: "APIBaseURL", defaultValue: "")
    }

    var currentEnvironment: String {
        return getValue(forKey: "CurrentEnvironment", defaultValue: "Development")
    }
}
