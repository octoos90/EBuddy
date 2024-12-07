//
//  User.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//


import Foundation

enum Gender: Int, Codable {
    case female = 0
    case male = 1
}

struct User: Codable, Identifiable {
    var id: String? // Firestore document ID
    var uid: String?
    var email: String?
    var phoneNumber: String?
    var gender: Gender?
    var ge: Int?
    var profileImageURL: String?
}
