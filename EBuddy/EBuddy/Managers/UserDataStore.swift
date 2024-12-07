//
//  UserDataStore.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI
import Combine

class UserDataStore: ObservableObject {
    @Published var userJSON: User? // Global state for selected user

    // Singleton instance for shared global access
    static let shared = UserDataStore()

    // Function to update the current user
    func updateUser(_ user: User) {
        DispatchQueue.main.async {
            self.userJSON = user
        }
    }

    // Function to clear the user (e.g., for logout)
    func clearUser() {
        DispatchQueue.main.async {
            self.userJSON = nil
        }
    }
}
