//
//  DraggablePlaceSheet.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI

struct DraggablePlaceSheet: View {
    @Binding var height: CGFloat

    let collapsedHeight: CGFloat
    let mediumHeight: CGFloat
    let expandedHeight: CGFloat
    let places: [Place]
    let onSelectPlace: (Place) -> Void
    let onTapImport: () -> Void

    @GestureState private var dragOffset: CGFloat = 0

    var currentHeight: CGFloat {
        max(collapsedHeight, min(expandedHeight, height - dragOffset))
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundStyle(.gray.opacity(0.35))
                .padding(.top, 10)
                .padding(.bottom, 12)

            if currentHeight > 180 {
                PlaceFeedContent(
                    places: places,
                    onSelectPlace: onSelectPlace
                )
                .transition(.opacity)
            }

            Spacer()

            BottomActionBar(onTapImport: onTapImport)
                .padding(.horizontal, 18)
                .padding(.bottom, 26)
        }
        .frame(maxWidth: .infinity)
        .frame(height: currentHeight)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: -8)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation.height
                }
                .onEnded { value in
                    let proposedHeight = height - value.translation.height

                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        if proposedHeight < (collapsedHeight + mediumHeight) / 2 {
                            height = collapsedHeight
                        } else if proposedHeight < (mediumHeight + expandedHeight) / 2 {
                            height = mediumHeight
                        } else {
                            height = expandedHeight
                        }
                    }
                }
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

struct PlaceFeedContent: View {
    let places: [Place]
    let onSelectPlace: (Place) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FilterChip(title: "Restaurant", icon: "fork.knife")
                    FilterChip(title: "Fast food")
                    FilterChip(title: "Activities")
                    FilterChip(title: "Nearby")
                }
                .padding(.horizontal, 18)
            }

            Text("Recent")
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.horizontal, 18)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    ForEach(places) { place in
                        PlaceRow(place: place)
                            .onTapGesture {
                                onSelectPlace(place)
                            }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 90)
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
            }

            Text(title)
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(.gray.opacity(0.25))
        }
    }
}
