//
//  CommentSheet.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import SwiftUI
import CoreData

struct CommentSheet: View {
    @ObservedObject var post: PostEntity
    var vm: FeedViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(Array(post.comments.enumerated()), id: \.0) { _, comment in
                        VStack(alignment: .leading) {
                            Text(comment)
                        }
                    }
                }

                HStack {
                    TextField("Add comment...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: send) {
                        Text("Send")
                    }
                }
                .padding()
            }
            .navigationTitle("Comments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func send() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        vm.addComment(trimmed, to: post)
        text = ""
    }
}


#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    // Create a mock Post entity for preview
    let post = PostEntity(context: context)
    post.id = UUID()
    post.descText = "Mock Post for Preview"
    post.locationText = "Bangalore"
    post.isLiked = false
    post.timestamp = Date()
    
    return CommentSheet(post: post, vm: FeedViewModel(context: context))
        .environment(\.managedObjectContext, context)
        .preferredColorScheme(.light)
}
