//
//  ProfileView.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Text("🐶")
                            .font(.largeTitle)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Guest User")
                                .font(.headline)

                            Text("Sign in to sync your places")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Your Content") {
                    Label("Collections", systemImage: "square.grid.2x2")
                    Label("Projects", systemImage: "map")
                    Label("Saved Places", systemImage: "bookmark")
                }

                Section("Settings") {
                    Label("Preferences", systemImage: "slider.horizontal.3")
                    Label("Notifications", systemImage: "bell")
                    Label("Privacy", systemImage: "lock")
                }

                Section {
                    Button("Sign In") {
                    }
                    .fontWeight(.semibold)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
