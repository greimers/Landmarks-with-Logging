/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI
import MapKit
import os

struct LandmarkDetail: View {
    
    var log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LandmarkDetail")

    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark
    @State private var showingSheet = false

    @State private var showMeTheMoney = false

    
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        ScrollView {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                MapView(coordinate: landmark.locationCoordinate)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)

                Button("Open in Maps") {
                    let destination = MKMapItem(placemark: MKPlacemark(coordinate: landmark.locationCoordinate))
                    destination.name = landmark.name
                    destination.openInMaps()
                }
                .padding()
            }

            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 24) {
                    CircleImage(image: landmark.image.resizable())
                        .frame(width: 160, height: 160)

                    VStack(alignment: .leading) {
                        HStack {
                            Text(landmark.name)
                                .font(.title)
                            FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                                .buttonStyle(.plain)
                        }

                        VStack(alignment: .leading) {
                            Text(landmark.park)
                            Text(landmark.state)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        if showMeTheMoney {
                            Button {
                                log.debug("Buy button clicked")
                                withAnimation {
                                    showingSheet.toggle()
                                }
                            } label: {
                                Label("Buy NFT", systemImage: "dollarsign.circle")
                                    .padding()
                            }
                        }
                    }
                }

                Divider()

                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
            .frame(maxWidth: 700)
            .offset(y: -50)
        }
        .navigationTitle(landmark.name)
        .sheet(isPresented: $showingSheet) {
            PurchaseSheet(showingSheet: $showingSheet, park: landmark)
            .frame(width: 400, height: 600, alignment: .center)
        }
        .onAppear {
            log.notice("Showing \(landmark.name)")
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        return LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
    }
}
