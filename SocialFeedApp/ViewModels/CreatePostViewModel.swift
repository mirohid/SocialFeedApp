//
//  CreatePostViewModel.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation
import SwiftUI
import CoreData
import Combine

final class CreatePostViewModel: ObservableObject {
    @Published var pickedImage: UIImage?
    @Published var descriptionText: String = ""
    @Published var locationText: String = ""

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func savePost() {
        let post = PostEntity(context: context)
        post.id = UUID()
        post.descText = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        post.locationText = locationText.trimmingCharacters(in: .whitespacesAndNewlines)
        post.timestamp = Date()
        post.isLiked = false
        post.comments = []

        if let img = pickedImage {
            post.imageData = img.jpegData(compressionQuality: 0.8)
        }

        do {
            try context.save()
            // You can choose to not reset here and instead reset explicitly from the view.
            // Keeping the existing behavior to clear image and description after save:
            DispatchQueue.main.async {
                self.pickedImage = nil
                self.descriptionText = ""
                // keep locationText if user wants
            }
        } catch {
            print("Failed saving post: \(error.localizedDescription)")
        }
    }

    func resetFields(clearLocation: Bool = false) {
        pickedImage = nil
        descriptionText = ""
        if clearLocation {
            locationText = ""
        }
    }
}
