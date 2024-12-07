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

                if let error = error {
                    self?.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents else {
                    self?.errorMessage = "No data found."
                    return
                }

                self?.users = documents.compactMap { document in
                    try? document.data(as: User.self)
                }
            }
        }
    }
}
