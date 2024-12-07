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
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
