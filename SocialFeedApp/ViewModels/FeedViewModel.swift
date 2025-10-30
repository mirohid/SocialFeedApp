//
//  FeedViewModel.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation
import CoreData
import Combine

final class FeedViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func toggleLike(on post: PostEntity) {
        post.isLiked.toggle()
        save()
    }

    func addComment(_ comment: String, to post: PostEntity) {
        var comments = post.comments
        comments.append(comment)
        post.comments = comments
        save()
    }

    func delete(_ post: PostEntity) {
        context.delete(post)
        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
}
