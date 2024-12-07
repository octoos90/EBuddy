//
//  UploadManager.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import Foundation
import FirebaseStorage

import Foundation
import FirebaseStorage

class UploadManager: NSObject, ObservableObject {
    static let shared = UploadManager()

    @Published var uploadProgress: Double = 0.0

    private let storage = Storage.storage()
    private lazy var backgroundSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.ebuddy.uploadManager")
        config.isDiscretionary = false
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    // Upload image data with progress reporting and background support
    func uploadImage(userId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let fileName = "profile.jpg"
        let storageRef = storage.reference().child("profile_images/\(userId)/\(fileName)")

        let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Fetch the download URL after upload
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }

        // Observe upload progress
        uploadTask.observe(.progress) { [weak self] snapshot in
            DispatchQueue.main.async {
                let progress = snapshot.progress?.fractionCompleted ?? 0.0
                self?.uploadProgress = progress
                print("Upload Progress: \(progress)")
            }
        }

        // Observe completion
        uploadTask.observe(.success) { _ in
            DispatchQueue.main.async {
                print("Upload completed successfully.")
            }
        }
    }
}

// MARK: - URLSessionDelegate
extension UploadManager: URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Background upload failed: \(error.localizedDescription)")
            } else {
                print("Background upload completed successfully.")
            }
        }
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Background session events finished for: \(session.configuration.identifier ?? "Unknown Session")")
    }
}
