//
//  UserDetailViewModel.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import FirebaseFirestore
import FirebaseStorage

class UserDetailViewModel: ObservableObject {
    @Published var user: User? // Specific user for display
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Double = 0.0
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // Fetch a single user by userId
    func fetchUser(userId: String) {
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
                    self?.user = try Firestore.Decoder().decode(User.self, from: data)
                } catch {
                    self?.errorMessage = "Failed to decode user data: \(error.localizedDescription)"
                }
            }
        }
    }

    // Upload profile image
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "InvalidImageData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data."])))
            return
        }

        isUploading = true
        let fileName = "profile.jpg"
        let storageRef = storage.reference().child("profile_images/\(userId)/\(fileName)")

        let uploadTask = storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            DispatchQueue.main.async {
                self?.isUploading = false
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            self?.getDownloadURL(storageRef: storageRef, userId: userId, completion: completion)
        }

        uploadTask.observe(.progress) { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.uploadProgress = Double(snapshot.progress?.fractionCompleted ?? 0.0)
            }
        }
    }

    // Helper Function to Get Download URL
    private func getDownloadURL(storageRef: StorageReference, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        storageRef.downloadURL { [weak self] url, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let url = url else {
                completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL."])))
                return
            }

            self?.updateUserProfileImageURL(userId: userId, imageURL: url.absoluteString, completion: completion)
        }
    }

    // Update Firestore with the new profile image URL
    private func updateUserProfileImageURL(userId: String, imageURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("USERS").document(userId).updateData(["profileImageURL": imageURL]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                DispatchQueue.main.async {
                    self.user?.profileImageURL = imageURL
                    self.successMessage = "Profile image updated successfully!"
                }
                completion(.success(()))
            }
        }
    }
}
