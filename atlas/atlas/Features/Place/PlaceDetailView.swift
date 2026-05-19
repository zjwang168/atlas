//
//  PlaceDetailView.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI

struct PlaceDetailView: View {
    let place: Place

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.gray.opacity(0.18))
                        .frame(height: 180)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(place.name)
                            .font(.title.bold())

                        Text(place.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }

                    Text(place.summary)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    HStack {
                        ForEach(place.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(.gray.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }

                    Button {
                    } label: {
                        Text("Add to Collection")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.black)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                    } label: {
                        Text("Plan in Project")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.gray.opacity(0.12))
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Place")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
