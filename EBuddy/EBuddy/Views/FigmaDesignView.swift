//
//  FigmaDesignView.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import SwiftUI

struct FigmaDesignView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FigmaCard(
                    name: "Zynx",
                    rating: 4.9,
                    reviews: 61,
                    price: 110.00,
                    isAvailable: true,
                    profileImageURL: "https://randomuser.me/api/portraits/women/10.jpg"
                )

                FigmaCard(
                    name: "John",
                    rating: 4.8,
                    reviews: 45,
                    price: 100.00,
                    isAvailable: false,
                    profileImageURL: "https://randomuser.me/api/portraits/men/10.jpg"
                )
            }
            .padding()
        }
        .navigationTitle("Figma Design")
    }
}
