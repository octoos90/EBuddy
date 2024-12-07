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
    
    init(){
        FirebaseApp.configure()
        AuthenticationManager.shared.signInAnonymously { result in
            switch result {
            case .success(let uid):
                print("Anonymous user signed in with UID: \(uid)")
            case .failure(let error):
                print("Failed to sign in anonymously: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            UserListView()
        }
    }
}
