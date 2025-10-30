//
//  Persistence.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    static let preview = PersistenceController(inMemory: true)

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = Self.createModel()
        container = NSPersistentContainer(name: "SocialFeed", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // PostEntity
        let postEntity = NSEntityDescription()
        postEntity.name = "PostEntity"
        postEntity.managedObjectClassName = NSStringFromClass(PostEntity.self)

        func attr(_ name: String, type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        let id = attr("id", type: .UUIDAttributeType)
        let imageData = attr("imageData", type: .binaryDataAttributeType, optional: true)
        let descText = attr("descText", type: .stringAttributeType, optional: true)
        let locationText = attr("locationText", type: .stringAttributeType, optional: true)
        let timestamp = attr("timestamp", type: .dateAttributeType)
        let isLiked = attr("isLiked", type: .booleanAttributeType)
        let commentsData = attr("commentsData", type: .binaryDataAttributeType, optional: true)

        postEntity.properties = [id, imageData, descText, locationText, timestamp, isLiked, commentsData]

        model.entities = [postEntity]
        return model
    }
}
