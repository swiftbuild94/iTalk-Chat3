//
//  MapView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 13/07/2022.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -34.603722, longitude: -58.381592),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @ObservedObject private var locationManager = LocationManager()
    @ObservedObject private var vmContacts = ContactsVM()
    
    private var homeLocation : [AnnotationItem] {
          guard let location = locationManager.location?.coordinate else {
              return []
          }
          return [.init(name: "Home", coordinate: location)]
      }
      
    var body: some View {
        Map(
            coordinateRegion: $locationManager.region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: homeLocation
        ) {
            MapPin(coordinate: $0.coordinate, tint: .red)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading ) {
                Button {
                    vmContacts.shouldShowLocation.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color.accentColor)
                        .dynamicTypeSize(.xxxLarge)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
