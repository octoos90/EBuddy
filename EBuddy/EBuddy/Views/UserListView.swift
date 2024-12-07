//
//  UserListView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text("UID: \(user.uid ?? "Unknown")")
                            Text("Email: \(user.email ?? "Unknown")")
                            Text("Phone: \(user.phoneNumber ?? "Unknown")")
                            Text("Gender: \(user.gender == .male ? "Male" : "Female")")
                        }
                    }
                    .refreshable {
                        viewModel.fetchUsers() // Refresh data on pull
                    }
                }
            }
            .navigationTitle("Users")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}
