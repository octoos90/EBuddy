//
//  UserDetailView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI

struct UserDetailView: View {
    @EnvironmentObject var userDataStore: UserDataStore // Access global state
    @StateObject private var viewModel = UserDetailViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    let userId: String // User ID to fetch details

    var body: some View {
        VStack {
            if let user = userDataStore.userJSON {
                VStack {
                    // Profile Image
                    if let profileImageURL = user.profileImageURL, let url = URL(string: profileImageURL) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } else if phase.error != nil {
                                Text("Failed to load image").foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    }

                    // User Details
                    Text("Email: \(user.email ?? "N/A")")
                    Text("Phone: \(user.phoneNumber ?? "N/A")")
                    Text("Gender: \(user.gender == .male ? "Male" : "Female")")
                    Text("UID: \(user.uid ?? "N/A")")

                    // Upload Profile Image Button
                    Button(action: { showImagePicker = true }) {
                        Text("Upload Profile Image")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    if viewModel.isUploading {
                        ProgressView(value: viewModel.uploadProgress)
                            .padding()
                    }
                }
            } else {
                Text("No user data available.").foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchUser(userId: userId, userDataStore: userDataStore)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage, let imageData = newImage.jpegData(compressionQuality: 0.8) {
                viewModel.uploadProfileImage(userId: userId, imageData: imageData, userDataStore: userDataStore) { result in
                    switch result {
                    case .success:
                        print("Image uploaded successfully!")
                    case .failure(let error):
                        print("Failed to upload image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
