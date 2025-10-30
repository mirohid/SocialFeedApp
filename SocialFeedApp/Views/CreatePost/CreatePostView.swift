//
//  CreatePostView.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//


import SwiftUI
import CoreData

struct CreatePostView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var vm = CreatePostViewModel()
    @State private var showImagePicker = false
    @State private var showConfirmAlert = false
    @State private var showSuccessAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Image Picker
                    Button(action: { showImagePicker = true }) {
                        if let img = vm.pickedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1))
                                    .frame(height: 220)
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                    Text("Select Image")
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $vm.pickedImage)
                    }

                    // MARK: - Description Field
                    TextField("Write a description...", text: $vm.descriptionText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // MARK: - Location Input
                    HStack {
                        TextField("Location (auto or type)", text: $vm.locationText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: fillLocationFromManager) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(.leading, 8)
                    }

                    // MARK: - Post Button
                    Button(action: {
                        showConfirmAlert = true
                    }) {
                        Label("Post", systemImage: "paperplane.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    .alert("Confirm Post", isPresented: $showConfirmAlert) {
                        Button("Confirm") {
                            // Save using the view model's internal context
                            vm.savePost()
                            showSuccessAlert = true
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Do you want to post this content?")
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Create Post")
            .alert("Post Created Successfully!", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    vm.resetFields()
                }
            }
        }
    }

    private func fillLocationFromManager() {
        if !locationManager.locationName.isEmpty {
            vm.locationText = locationManager.locationName
        } else {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let locationManager = LocationManager()
    locationManager.locationName = "Kolkata, India"
    
    return CreatePostView()
        .environment(\.managedObjectContext, context)
        .environmentObject(locationManager)
        .preferredColorScheme(.light)
}
