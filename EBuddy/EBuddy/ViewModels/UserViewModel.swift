//
//  UserViewModel.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import FirebaseFirestore
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()

    func fetchUsers() {
        isLoading = true
        errorMessage = nil

        db.collection("USERS").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                }
                return
            }

            guard let documents = snapshot?.documents else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No users found."
                }
                return
            }

            DispatchQueue.main.async {
                do {
                    // Map Firestore documents to `User` struct
                    self?.users = try documents.map { document in
                        var user = try Firestore.Decoder().decode(User.self, from: document.data())
                        user.id = document.documentID // Assign Firestore document ID
                        return user
                    }
                } catch {
                    self?.errorMessage = "Failed to decode users: \(error.localizedDescription)"
                }
            }
        }
    }
}
