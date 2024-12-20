//
//  UserDetailViewModel.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import FirebaseFirestore
import FirebaseStorage
import Combine

class UserDetailViewModel: ObservableObject {
    @Published var user: User? // User details
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe the UploadManager for upload progress updates
        UploadManager.shared.$uploadProgress
            .receive(on: DispatchQueue.main)
            .assign(to: &$uploadProgress)
    }

    // Fetch a single user by userId and update global state
    func fetchUser(userId: String, userDataStore: UserDataStore) {
        db.collection("USERS").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
                }
                return
            }

            guard let data = snapshot?.data() else {
                DispatchQueue.main.async {
                    self?.errorMessage = "User not found."
                }
                return
            }

            DispatchQueue.main.async {
                do {
                    var user = try Firestore.Decoder().decode(User.self, from: data)
                    user.id = userId // Assign document ID
                    self?.user = user
                    userDataStore.updateUser(user) // Update global UserDataStore
                } catch {
                    self?.errorMessage = "Failed to decode user data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Upload profile image and update global state
    func uploadProfileImage(userId: String, imageData: Data, userDataStore: UserDataStore, completion: @escaping (Result<Void, Error>) -> Void) {
        isUploading = true
        uploadProgress = 0.0

        // Use UploadManager to handle the upload process
        UploadManager.shared.uploadImage(userId: userId, imageData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
            }

            switch result {
            case .success(let imageURL):
                self?.updateUserProfileImageURL(userId: userId, imageURL: imageURL, userDataStore: userDataStore, completion: completion)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                }
                completion(.failure(error))
            }
        }
    }

    // Update Firestore with the new profile image URL and global state
    private func updateUserProfileImageURL(userId: String, imageURL: String, userDataStore: UserDataStore, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("USERS").document(userId).updateData(["profileImageURL": imageURL]) { [weak self] error in
            if let error = error {
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    self?.user?.profileImageURL = imageURL
                    self?.successMessage = "Profile image updated successfully!"
                    if let updatedUser = self?.user {
                        userDataStore.updateUser(updatedUser) // Update global UserDataStore
                    }
                }
                completion(.success(()))
            }
        }
    }
}
