//
//  UserQueryManager.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import FirebaseFirestore

class UserQueryManager {
    private let db = Firestore.firestore()

    /// Fetches users based on multiple queries
    func fetchFilteredUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        // Reference to the USERS collection
        let usersRef = db.collection("USERS")
        
        // Create the query with all conditions
        let query = usersRef
            .whereField("gender", isEqualTo: Gender.female.rawValue) // Filter by gender
            .order(by: "lastActive", descending: true) // Recently Active
            .order(by: "rating", descending: true) // Highest Rating
            .order(by: "price", descending: false) // Lowest Service Pricing

        // Execute the query
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([])) // Return empty array if no data
                return
            }

            do {
                // Map Firestore documents to User models
                let users = try documents.map { document -> User in
                    return try Firestore.Decoder().decode(User.self, from: document.data())
                }
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
