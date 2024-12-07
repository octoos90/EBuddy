//
//  RootView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI
import Firebase
import FirebaseAuth

class AppState: ObservableObject {
    @Published var userId: String? = nil
    @Published var isLoading = true

    func authenticateUser() {
        let timeout = DispatchTime.now() + 10 // 10-second timeout
        DispatchQueue.main.asyncAfter(deadline: timeout) {
            if self.isLoading {
                print("Fallback timeout reached.")
                self.isLoading = false
            }
        }

        Auth.auth().signInAnonymously { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Authentication failed: \(error.localizedDescription)")
                    self.userId = nil
                } else if let user = authResult?.user {
                    print("Authenticated successfully with UID: \(user.uid)")
                    self.userId = user.uid
                }
                self.isLoading = false
            }
        }
    }
}

struct RootView: View {
    @StateObject private var appState = AppState() // Initialize AppState here

    var body: some View {
        if appState.isLoading {
            ProgressView("Loading...")
                .onAppear {
                    appState.authenticateUser() // Authenticate when the view appears
                }
        } else {
            MenuView(userId: appState.userId) // Pass userId to MenuView
        }
    }
}
