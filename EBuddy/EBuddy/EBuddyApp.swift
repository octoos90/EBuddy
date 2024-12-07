//
//  EBuddyApp.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import SwiftUI
import Firebase

@main
struct EBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateHandler.self) var appDelegateHandler
    @StateObject private var userDataStore = UserDataStore.shared // Initialize UserDataStore

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(userDataStore) // Inject UserDataStore globally
        }
    }
}


class AppDelegateHandler: NSObject, UIApplicationDelegate {
    var backgroundUploadCompletionHandler: (() -> Void)?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure() // Ensure Firebase is configured only once
            print("Firebase configured.")
        }
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        print("Handling background events for session: \(identifier)")
        backgroundUploadCompletionHandler = completionHandler
    }
}
