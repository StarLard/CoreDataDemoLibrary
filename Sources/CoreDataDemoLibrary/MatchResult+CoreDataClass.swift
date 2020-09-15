//
//  MatchResult+CoreDataClass.swift
//  CoreDataDemoLibrary
//
//  Created by Caleb Friden on 9/15/20.
//
//

import Foundation
import CoreData
import os.log

public class MatchResult: NSManagedObject {
    static let entityName: String = "MatchResult"
    
    public override func willSave() {
        super.willSave()
        let now = Date()
        guard let updated = updatedAt else {
            updatedAt = now
            return
        }
        guard now > updated else { return }
        updatedAt = now
    }
    
    public convenience init?(insertInto managedObjectContext: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: managedObjectContext) else {
            Logger.models.critical("Failed to find entity \(Self.entityName, privacy: .public) associated with \(String(describing: type(of: Self.self)), privacy: .public) in managed object contect")
            return nil
        }
        self.init(entity: entity, insertInto: managedObjectContext)
    }
    
    public convenience init?(didPlayerWin: Bool, opponentClassSlug: String, opponentImageURL: URL,
                             playerDeck: PlayerDeck, gameModeSlug: String, note: String? = nil,
                             insertInto managedObjectContext: NSManagedObjectContext) {
        self.init(insertInto: managedObjectContext)
        let now = Date()
        self.id = UUID()
        self.opponentClassSlug = opponentClassSlug
        self.opponentImageURL = opponentImageURL
        self.playerDeck = playerDeck
        self.gameModeSlug = gameModeSlug
        self.createdAt = now
        self.updatedAt = now
        self.note = note
    }
    
    /// Used for testing so that deck is not needed.
    internal convenience init?(didPlayerWin: Bool, opponentClassSlug: String, opponentImageURL: URL,
                               gameModeSlug: String, note: String? = nil,
                               insertInto managedObjectContext: NSManagedObjectContext) {
        self.init(insertInto: managedObjectContext)
        let now = Date()
        self.id = UUID()
        self.opponentClassSlug = opponentClassSlug
        self.opponentImageURL = opponentImageURL
        self.playerDeck = nil
        self.gameModeSlug = gameModeSlug
        self.createdAt = now
        self.updatedAt = now
        self.note = note
    }
}
