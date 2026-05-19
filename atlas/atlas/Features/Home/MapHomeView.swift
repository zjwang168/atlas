//
//  MapHomeView.swift
//  atlas
//
//  Created by Zijin Wang on 5/18/26.
//

import SwiftUI
import MapKit

struct MapHomeView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    @State private var sheetHeight: CGFloat = 120
    @State private var showProfile = false
    @State private var selectedPlace: Place?

    private let collapsedHeight: CGFloat = 120
    private let mediumHeight: CGFloat = 430
    private let expandedHeight: CGFloat = 720

    private let places = [
        Place(
            name: "Noma Restaurant",
            subtitle: "Downtown Seattle",
            summary: "From Eater: A saved restaurant with AI-generated summary.",
            latitude: 47.6095,
            longitude: -122.3419,
            tags: ["Restaurant", "Nordic", "Saved"]
        ),
        Place(
            name: "Seattle Coffee",
            subtitle: "Capitol Hill",
            summary: "A cozy coffee spot saved from an imported post.",
            latitude: 47.6152,
            longitude: -122.3208,
            tags: ["Coffee", "Cozy", "Nearby"]
        ),
        Place(
            name: "Hidden Sushi",
            subtitle: "Belltown",
            summary: "A quiet sushi place recommended for dinner.",
            latitude: 47.6131,
            longitude: -122.3450,
            tags: ["Sushi", "Dinner", "Hidden Gem"]
        )
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    ForEach(places) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            Button {
                                selectedPlace = place
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 52, height: 52)
                                        .shadow(radius: 6)

                                    Image(systemName: "fork.knife")
                                        .font(.title3)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()

                        Button {
                            showProfile = true
                        } label: {
                            Text("🐶")
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        .padding(.top, 56)
                        .padding(.trailing, 24)
                    }

                    Spacer()
                }

                DraggablePlaceSheet(
                    height: $sheetHeight,
                    collapsedHeight: collapsedHeight,
                    mediumHeight: mediumHeight,
                    expandedHeight: min(expandedHeight, geometry.size.height * 0.86),
                    places: places,
                    onSelectPlace: { place in
                        selectedPlace = place
                    }
                )
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    MapHomeView()
}
