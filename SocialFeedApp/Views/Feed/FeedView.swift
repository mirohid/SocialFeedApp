//
//  FeedView.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//


import SwiftUI
import CoreData

struct FeedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var vm = FeedViewModel()
    @EnvironmentObject private var locationManager: LocationManager

    @FetchRequest(entity: PostEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.timestamp, ascending: false)])
    private var posts: FetchedResults<PostEntity>

    @State private var selectedPostForComments: PostEntity?
    @State private var showShareAlert: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(posts) { post in
                    PostRow(post: post,
                            onLike: { vm.toggleLike(on: post) },
                            onComment: { selectedPostForComments = post },
                            onShare: { simulateShare() })
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Feed")
            .sheet(item: $selectedPostForComments) { post in
                CommentSheet(post: post, vm: vm)
            }
            .alert("Shared!", isPresented: $showShareAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    private func delete(offsets: IndexSet) {
        offsets.map { posts[$0] }.forEach { vm.delete($0) }
    }

    private func simulateShare() {
        // Simulated share feedback
        showShareAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            showShareAlert = false
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let locationManager = LocationManager()
    
    // Create mock posts for preview
    for i in 1...3 {
        let newPost = PostEntity(context: context)
        newPost.id = UUID()
        newPost.descText = "Sample Post \(i)"
        newPost.locationText = "City \(i)"
        newPost.isLiked = i % 2 == 0
        newPost.timestamp = Date()
    }
    
    return FeedView()
        .environment(\.managedObjectContext, context)
        .environmentObject(locationManager)
        .preferredColorScheme(.light)
}
