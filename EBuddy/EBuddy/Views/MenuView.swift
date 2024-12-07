//
//  MenuView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import SwiftUI

struct MenuView: View {
    let userId: String? // Passed from EBuddyApp

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // First Menu
                NavigationLink(destination: UserListView()) {
                    Text("View User List")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Menu")
        }
        .onAppear {
            print("MenuView userId: \(userId ?? "nil")") // Debug userId
        }
    }
}

