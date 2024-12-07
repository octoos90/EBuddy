//
//  UserDetailView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI

struct UserDetailView: View {
    @StateObject private var viewModel = UserDetailViewModel() // Use a separate ViewModel for details
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    let userId: String // User ID to fetch details

    var body: some View {
        VStack {
            if let user = viewModel.user {
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
                            .progressViewStyle(LinearProgressViewStyle())
                            .animation(.easeInOut, value: viewModel.uploadProgress)
                    }
                }
            } else if viewModel.errorMessage != nil {
                Text(viewModel.errorMessage ?? "Unknown error").foregroundColor(.red)
            } else {
                ProgressView("Loading user details...")
            }
        }
        .onAppear {
            viewModel.fetchUser(userId: userId)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage) // Pass the selectedImage binding to the ImagePicker.
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage, let imageData = newImage.jpegData(compressionQuality: 0.8) {
                viewModel.uploadProfileImage(userId: userId, imageData: imageData) { result in
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
