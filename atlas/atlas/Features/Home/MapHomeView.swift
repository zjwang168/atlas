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
    @State private var showImportSheet = false
    @State private var showImportPreview = false
    @State private var selectedPlace: Place?
    @State private var places: [Place] = []
    @State private var extractedPlaces: [ExtractedPlace] = []

    private let collapsedHeight: CGFloat = 120
    private let mediumHeight: CGFloat = 430
    private let expandedHeight: CGFloat = 720

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
                    },
                    onTapImport: {
                        showImportSheet = true
                    }
                )
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showImportSheet) {
            ImportSheetView { extracted in
                extractedPlaces = extracted

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showImportPreview = true
                }
            }
        }
        .sheet(isPresented: $showImportPreview) {
            ImportPreviewView(places: extractedPlaces) { approvedPlaces in
                Task {
                    do {
                        for place in approvedPlaces {
                            try await PlaceService.shared.createPlace(from: place)
                        }

                        await loadPlaces()
                    } catch {
                        print("Failed to save extracted places:", error)
                    }
                }
            }
        }
        .sheet(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            await loadPlaces()
        }
    }

    private func loadPlaces() async {
        do {
            let fetchedPlaces = try await PlaceService.shared.fetchPlaces()

            self.places = fetchedPlaces.compactMap { dto in
                guard let latitude = dto.latitude,
                      let longitude = dto.longitude else {
                    return nil
                }

                return Place(
                    name: dto.name,
                    subtitle: dto.subtitle ?? dto.city ?? "Saved place",
                    summary: dto.ai_summary ?? "No summary yet.",
                    latitude: latitude,
                    longitude: longitude,
                    tags: [
                        dto.category ?? "Place",
                        dto.city ?? "Saved"
                    ]
                )
            }
        } catch {
            print("Failed to fetch places:", error)
        }
    }
}

#Preview {
    MapHomeView()
}
