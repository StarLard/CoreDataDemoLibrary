import XCTest
import CoreData
@testable import CoreDataDemoLibrary

final class CoreDataDemoLibraryTests: XCTestCase {
    func testMatchResult() {
        let dataStore = DataStore(kind: .inMemory)
        let maybeMatch = MatchResult(didPlayerWin: true, opponentClassSlug: "mage",
                                     opponentImageURL: URL(fileURLWithPath: "url"),
                                     gameModeSlug: "arena", insertInto: dataStore.managedObjectContext)
        XCTAssertNotNil(maybeMatch)
        guard let match = maybeMatch else { return }
        dataStore.save()
        let fetchRequest: NSFetchRequest<MatchResult> = MatchResult.fetchRequest()
        XCTAssertNotNil(match.id)
        if let id = match.id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }
        var fetchedMatches: [MatchResult]?
        XCTAssertNoThrow(fetchedMatches = try dataStore.managedObjectContext.fetch(fetchRequest))
        XCTAssertNotNil(fetchedMatches)
        XCTAssertTrue(fetchedMatches?.count == 1)
        guard let fetchedMatch = fetchedMatches?.first else { return }
        XCTAssertEqual(match, fetchedMatch)
    }
    
    func testPlayerDeck() {
        let dataStore = DataStore(kind: .inMemory)
        let maybeDeck = PlayerDeck(name: "Free Hong Kong", deckcode: "1234567890",
                                   playerClassSlug: "jeff", gameModeSlug: "esports",
                                   imageURL: URL(fileURLWithPath: "url"), insertInto: dataStore.managedObjectContext)
        XCTAssertNotNil(maybeDeck)
        guard let deck = maybeDeck else { return }
        dataStore.save()
        let fetchRequest: NSFetchRequest<PlayerDeck> = PlayerDeck.fetchRequest()
        if let id = deck.id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        }
        var fetchedDecks: [PlayerDeck]?
        XCTAssertNoThrow(fetchedDecks = try dataStore.managedObjectContext.fetch(fetchRequest))
        XCTAssertNotNil(fetchedDecks)
        XCTAssertTrue(fetchedDecks?.count == 1)
        guard let fetchedDeck = fetchedDecks?.first else { return }
        XCTAssertEqual(deck, fetchedDeck)
    }

    static var allTests = [
        ("testMatchResult", testMatchResult),
        ("testPlayerDeck", testPlayerDeck)
    ]
}
