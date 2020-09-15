//
//  DataStore.swift
//  CoreDataDemoLibrary
//
//  Created by Caleb Friden on 9/15/20.
//

import Foundation
import CoreData
import os.log

public final class DataStore {
    public enum Kind {
        case inMemory
        case cloud
    }
    
    // MARK: Public
    
    public var managedObjectContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    public func save() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
            Logger.dataStore.debug("Successfully saved managed object context.")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: Private
        
    private let persistentContainer: NSPersistentContainer
    
    public init(kind: Kind = .cloud, shouldInitializeCloudKitSchema: Bool = false) {
        guard let managedObjectModelURL = Bundle.module.url(forResource: "CoreDataDemoLibrary", withExtension: "momd") else {
            fatalError("Failed to find a managed object model.")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: managedObjectModelURL) else {
            fatalError("Failed to load managed object model from \(managedObjectModelURL)")
        }
        
        switch kind {
        case .inMemory:
            persistentContainer = NSPersistentContainer(name: "CoreDataDemoLibrary", managedObjectModel: managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            persistentContainer.persistentStoreDescriptions = [description]
        case .cloud:
            persistentContainer = NSPersistentCloudKitContainer(name: "CoreDataDemoLibrary", managedObjectModel: managedObjectModel)
            guard let description = persistentContainer.persistentStoreDescriptions.first else {
                fatalError("Failed to retrieve a persistent store description.")
            }
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "com.calebfriden.hearth-keeper.ios")
            NotificationCenter.default.addObserver(self, selector: #selector(handlePersistentStoreRemoteChange),
                                                   name: .NSPersistentStoreRemoteChange, object: nil)
            
        }
            
        persistentContainer.loadPersistentStores { (description, error) in
            if let loadError = error {
                fatalError("Error loading persistent store \(description): \(loadError)")
            } else {
                Logger.dataStore.notice("Successfully loaded persistent store: \(description)")
            }
        }
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        guard shouldInitializeCloudKitSchema, let container = persistentContainer as? NSPersistentCloudKitContainer else { return }
        do {
            try container.initializeCloudKitSchema()
            Logger.dataStore.notice("Successfully initialized CloudKit schema.")
        } catch {
            Logger.dataStore.fault("Unable to initialize CloudKit schema: \(error.localizedDescription, privacy: .public)")
        }
    }
    
    // MARK: Private
    
    @objc private func handlePersistentStoreRemoteChange() {
        Logger.dataStore.info("Recieved change from remote persistent store")
    }
}
