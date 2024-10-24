import Foundation
import CoreLocation
import Combine
import SwiftUI
import MapKit

enum MapStyle: String {
    case standard = "Standard"
    case hybrid = "Hybrid"
}

struct GoogleMap: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000))
    @State private var routes: [MKRoute] = []
    @State private var selectedMarker: String? // Track the selected marker
    @State private var mapType: MapStyle = .standard
    @State private var travelTimeMUP: String = "" // String to display travel time for MUP
    @State private var travelTimeVatrogasna: String = "" // String for Vatrogasna
    @State private var travelTimeBolnica: String = "" // String for Bolnica

    private let vatrogasna = CLLocationCoordinate2D(latitude: 43.146619138092234, longitude: 20.516773956688624)
    private let mup = CLLocationCoordinate2D(latitude: 43.140394363891126, longitude: 20.513000045311273)
    private let bolnica = CLLocationCoordinate2D(latitude: 43.133982973157046, longitude: 20.511566970189953)

    var body: some View {
        VStack {
            Picker("Map Style", selection: $mapType) {
                Text("Standard").tag(MapStyle.standard)
                Text("Hybrid").tag(MapStyle.hybrid)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ZStack {
                // Mapa
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    
                    Annotation("My location", coordinate: locationManager.location?.coordinate ?? .init()) {
                        ZStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.blue.opacity(0.25))
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.blue)
                        }
                    }

                    // Custom annotations
                    Annotation("Vatrogasna stanica", coordinate: vatrogasna) {
                        VStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: selectedMarker == "Vatrogasna" ? 40 : 20))
                                .foregroundColor(.yellow)
                            Text("Vatrogasna")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                        .onTapGesture {
                            selectedMarker = "Vatrogasna"
                        }
                    }
                    
                    Annotation("MUP Srbije", coordinate: mup) {
                        VStack {
                            Image(systemName: "building.fill")
                                .font(.system(size: selectedMarker == "MUP Srbije" ? 40 : 20))
                                .foregroundColor(.blue)
                            Text("MUP")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            selectedMarker = "MUP Srbije"
                        }
                    }
                    
                    Annotation("Opšta Bolnica Novi Pazar", coordinate: bolnica) {
                        VStack {
                            Image(systemName: "cross.fill")
                                .font(.system(size: selectedMarker == "Bolnica" ? 40 : 20))
                                .foregroundColor(.red)
                            Text("Bolnica")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .onTapGesture {
                            selectedMarker = "Bolnica"
                        }
                    }
                    
                    ForEach(routes, id: \.self) { route in
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                }
                .mapStyle(mapType == .standard ? .standard : .hybrid)
                .onAppear {
                    if let userLocation = locationManager.location {
                        cameraPosition = .region(MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                    }
                }
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                
                // VStack sa dugmadima na vrhu
                VStack {
                    HStack(spacing: 15) {
                        Spacer()
                        Button(action: {
                            fetchRoute(to: mup, for: "MUP")
                        }) {
                            VStack {
                                Image(systemName: "building.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                Text("MUP")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Text(travelTimeMUP)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        

                        Button(action: {
                            fetchRoute(to: vatrogasna, for: "Vatrogasna")
                        }) {
                            VStack {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                                Text("Vatrogasna")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                Text(travelTimeVatrogasna)
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        

                        Button(action: {
                            fetchRoute(to: bolnica, for: "Bolnica")
                        }) {
                            VStack {
                                Image(systemName: "cross.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                                Text("Bolnica")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Text(travelTimeBolnica)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Spacer()
                    }
                    .padding()
                    Spacer() // Ovo omogućava da dugmad budu na vrhu
                }
            }
        }
    }
    
    func fetchRoute(to destinationCoordinate: CLLocationCoordinate2D, for location: String) {
        guard let userLocation = locationManager.location else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: .init(coordinate: destinationCoordinate))

        Task {
            if let result = try? await MKDirections(request: request).calculate() {
                routes = result.routes
                if let rect = result.routes.first?.polyline.boundingMapRect {
                    cameraPosition = .rect(rect)
                }
                
                // Get travel time in minutes
                if let travelTimeInSeconds = result.routes.first?.expectedTravelTime {
                    let travelTimeInMinutes = Int(travelTimeInSeconds / 60)
                    let travelTimeString = "\(travelTimeInMinutes) min"

                    // Update specific travel time based on location
                    switch location {
                    case "MUP":
                        travelTimeMUP = travelTimeString
                    case "Vatrogasna":
                        travelTimeVatrogasna = travelTimeString
                    case "Bolnica":
                        travelTimeBolnica = travelTimeString
                    default:
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    GoogleMap()
}

