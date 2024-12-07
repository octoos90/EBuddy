//
//  AuthenticationManager.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func signInAnonymously(completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let user = authResult?.user {
                print("Signed in anonymously with UID: \(user.uid)")
                completion(.success(user.uid))
            }
        }
    }
}
