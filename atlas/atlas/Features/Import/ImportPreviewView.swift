//
//  ImportPreviewView.swift
//  atlas
//
//  Created by Zijin Wang on 5/21/26.
//

import SwiftUI

struct ExtractedPlace: Identifiable {
    let id = UUID()

    var name: String
    var address: String
    var summary: String
    var category: String
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
}

struct ImportPreviewView: View {
    @Environment(\.dismiss) private var dismiss

    @State var places: [ExtractedPlace]

    var onSave: ([ExtractedPlace]) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(places.first?.city ?? "Places")
                                .font(.largeTitle.bold())

                            Text("Review what Atlas found before saving.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 22)
                        .padding(.top, 18)

                        VStack(spacing: 14) {
                            ForEach(places) { place in
                                HStack(alignment: .top, spacing: 14) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(place.name)
                                            .font(.headline)

                                        Text(place.address)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)

                                        Text(place.summary)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                            .italic()
                                            .lineLimit(2)
                                    }

                                    Spacer()

                                    Button {
                                        delete(place)
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.headline)
                                            .foregroundStyle(.black)
                                            .frame(width: 42, height: 42)
                                            .background(Color(.secondarySystemBackground))
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(16)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.bottom, 120)
                    }
                }

                Button {
                    onSave(places)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save to Map")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(places.isEmpty ? Color.gray.opacity(0.25) : Color.black)
                    .foregroundStyle(places.isEmpty ? .gray : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .disabled(places.isEmpty)
                .padding(.horizontal, 22)
                .padding(.bottom, 22)
                .background(.ultraThinMaterial)
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }

    private func delete(_ place: ExtractedPlace) {
        places.removeAll { $0.id == place.id }
    }
}

#Preview {
    ImportPreviewView(
        places: [
            ExtractedPlace(
                name: "Hidden Sushi",
                address: "Downtown Seattle",
                summary: "Great omakase and late night ramen.",
                category: "restaurant",
                city: "Seattle",
                country: "USA",
                latitude: 47.6080,
                longitude: -122.3350
            )
        ]
    ) { _ in }
}
