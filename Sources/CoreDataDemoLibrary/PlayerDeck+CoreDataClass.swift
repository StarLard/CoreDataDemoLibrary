//
//  PlayerDeck+CoreDataClass.swift
//  CoreDataDemoLibrary
//
//  Created by Caleb Friden on 9/15/20.
//
//

import Foundation
import CoreData
import os.log

public class PlayerDeck: NSManagedObject {
    static let entityName: String = "PlayerDeck"
    
    public var matchResultsSet: Set<MatchResult>? {
        get { matchResults as? Set<MatchResult> }
        set { matchResults = newValue.map({ $0  as NSSet }) }
    }
    
    /// Decimal between 0 and 1 which represents the winrate of this deck.
    ///
    /// A winrate of 0.5 represents a 50% winrate. If no games have been played, returns `nil`.
    public var winrate: Double? {
        guard let numberOfMatches = matchResultsSet?.count, numberOfMatches > 0 else { return nil }
        let numberOfWins = (matchResultsSet ?? []).filter(\.didPlayerWin).count
        return Double(numberOfWins) / Double(numberOfMatches)
    }
    
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
    
    public convenience init?(name: String, deckcode: String, playerClassSlug: String,
                             gameModeSlug: String, imageURL: URL,
                             insertInto managedObjectContext: NSManagedObjectContext) {
        self.init(insertInto: managedObjectContext)
        let now = Date()
        self.id = UUID()
        self.name = name
        self.isArchived = false
        self.deckcode = deckcode
        self.playerClassSlug = playerClassSlug
        self.gameModeSlug = gameModeSlug
        self.imageURL = imageURL
        self.createdAt = now
        self.updatedAt = now
        self.matchResults = []
    }
}
