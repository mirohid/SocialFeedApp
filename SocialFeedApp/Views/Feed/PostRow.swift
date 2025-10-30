//
//  PostRow.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//


import SwiftUI
import CoreData

struct PostRow: View {
    @ObservedObject var post: PostEntity
    var onLike: () -> Void
    var onComment: () -> Void
    var onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = post.uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 300)
                    .clipped()
                    .cornerRadius(8)
            } else {
                // Placeholder
                Rectangle()
                    .fill(Color(UIColor.secondarySystemFill))
                    .frame(height: 180)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .opacity(0.6)
                    }
                    .cornerRadius(8)
            }

            if let desc = post.descText, !desc.isEmpty {
                Text(desc)
                    .font(.body)
            }

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(post.locationText ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                if let ts = post.timestamp {
                    Text(DateFormatter.shortDateTime.string(from: ts))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 20) {
                Button(action: onLike) {
                    Label(post.isLiked ? "Liked" : "Like", systemImage: post.isLiked ? "heart.fill" : "heart")
                }

                Button(action: onComment) {
                    Label("Comment", systemImage: "bubble.right")
                }

                Button(action: onShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

                Spacer()
            }
            .buttonStyle(BorderlessButtonStyle())

            if !post.comments.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(post.comments.enumerated()), id: \.0) { _, comment in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .frame(width: 32, height: 32)
                                .opacity(0.2)
                            VStack(alignment: .leading) {
                                Text("User")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(comment)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let samplePost = PostEntity(context: context)
    samplePost.id = UUID()
    samplePost.descText = "Just chilling by the river with friends ☀️"
    samplePost.locationText = "Goa, India"
    samplePost.isLiked = true
    samplePost.timestamp = Date()
    
    return PostRow(
        post: samplePost,
        onLike: {},
        onComment: {},
        onShare: {}
    )
    .environment(\.managedObjectContext, context)
    .previewLayout(.sizeThatFits)
    .padding()
    .preferredColorScheme(.light)
}
