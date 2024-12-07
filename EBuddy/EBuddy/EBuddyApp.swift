//
//  EBuddyApp.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import SwiftUI

@main
struct EBuddyApp: App {
    // Use UIApplicationDelegateAdaptor to manage background tasks
    @UIApplicationDelegateAdaptor(AppDelegateHandler.self) var appDelegateHandler

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegateHandler: NSObject, UIApplicationDelegate {
    var backgroundUploadCompletionHandler: (() -> Void)?

    // Handle background URL session events
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("Handling background events for session: \(identifier)")
        backgroundUploadCompletionHandler = completionHandler
    }
}
