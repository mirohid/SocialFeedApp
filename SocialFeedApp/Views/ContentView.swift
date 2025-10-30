//
//  ContentView.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        TabView {
            FeedView()
                .tabItem { Label("Feed", systemImage: "list.bullet") }

            CreatePostView()
                .tabItem { Label("Create", systemImage: "plus.square") }
        }
        .environmentObject(locationManager)
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

