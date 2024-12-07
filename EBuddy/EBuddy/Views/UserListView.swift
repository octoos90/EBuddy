//
//  UserListView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    @EnvironmentObject var userDataStore: UserDataStore // Access global UserDataStore
    
    var body: some View {
        VStack {
            // Show loading indicator while data is being fetched
            if viewModel.isLoading {
                ProgressView("Loading users...")
                    .padding()
            }

            // Show error message if there's an error
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // List of users
            List(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(userId: user.uid ?? "")
                    .onAppear {
                        userDataStore.updateUser(user) // Update global UserJSON in UserDataStore
                    }
                ) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.email ?? "No Email")
                                .font(.headline)
                            Text(user.phoneNumber ?? "No Phone Number")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Gender: \(user.gender == .male ? "Male" : "Female")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if let profileImageURL = user.profileImageURL, let url = URL(string: profileImageURL) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                } else {
                                    ProgressView()
                                }
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .refreshable {
                viewModel.fetchUsers() // Add pull-to-refresh functionality
            }
        }
        .onAppear {
            viewModel.fetchUsers() // Fetch users when the view appears
        }
    }
}
