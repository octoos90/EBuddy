//
//  FigmaCard.swift
//  EBuddy
//
//  Created by Octo Siswardhono on 07/12/24.
//

import SwiftUI

struct FigmaCard: View {
    var name: String
    var rating: Double
    var reviews: Int
    var price: Double
    var isAvailable: Bool
    var profileImageURL: String
    var games: [String] = ["CallOfDuty", "MobileLegends", "GamePlaceholder"]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("CardBackground"))
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 10) {
                // Header Section
                HStack {
                    Text(name)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)

                    if isAvailable {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.blue)

                    Image(systemName: "camera.fill")
                        .foregroundColor(.blue)
                }

                // Profile Image with Overlapping Circles and Mic Button
                ZStack(alignment: .bottom) {
                    // Profile Image
                    AsyncImage(url: URL(string: profileImageURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else if phase.error != nil {
                            Text("Image failed to load")
                                .frame(width: 300, height: 400)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            ProgressView()
                                .frame(width: 300, height: 400)
                        }
                    }

                    // Overlapping Game Circles and Mic Button
                    HStack(spacing: 15) {
                        // Overlapping Game Circles
                        HStack(spacing: -15) {
                            ForEach(games, id: \.self) { game in
                                Image(game)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }

                        Spacer()

                        // Microphone Button
                        Button(action: {}) {
                            Image(systemName: "mic.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color.pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                        }
                        .frame(width: 50, height: 50) // Matches circle dimensions
                    }
                    .padding(.horizontal, 20) // Align horizontally within the image
                    .padding(.bottom, -20) // Align properly at the bottom edge of the image
                }

                // Rating and Price Section
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.subheadline)

                        Text("\(rating, specifier: "%.1f")")
                            .font(.subheadline)
                            .foregroundColor(.black)

                        Text("(\(reviews))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("🔥 \(price, specifier: "%.2f")/Hr")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.red)
                }.padding(.top, 16)
            }
            .padding()
        }
        .frame(width: 320) // Match card width
        .padding(.horizontal)
    }
}
