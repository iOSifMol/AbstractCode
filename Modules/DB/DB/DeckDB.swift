//
//  DeckDB.swift
//  DB
//
//  Created by Iosif Moldovan on 07.03.2022.
//

import Foundation
import CoreData
import Models

public class DeckDB {
  // MARK: - Public Methods
  public init() {
    // offer a public initializer
  }
  
  public func getStoredHand<Hand: Handable>(_ type: Hand.Type) -> Hand? {
    do {
      let dbHands = try dbContext.fetch(DBHand.fetchRequest()) as? [DBHand]
      guard let lastHand = dbHands?.last else { return nil }
      return lastHand.handable()
    } catch {
      fatalError("Failed fetch card with error: \(error)")
    }
  }
  
  public func save<Hand: Handable>(hand: Hand) {
    DBHand.create(from: hand, in: dbContext)
    saveContext()
  }
  
  public func deleteAllHands() {
    do {
      let dbHands = try dbContext.fetch(DBHand.fetchRequest()) as? [DBHand]
      dbHands?.forEach({ dbContext.delete($0) })
      saveContext()
    } catch {
      fatalError("Failed fetch card with error: \(error)")
    }
  }

  // MARK: - DB Helpers
  private lazy var persistentContainer: NSPersistentContainer = {
    // load persistent container from current framework bundle
    guard let modelURL = Bundle(for: Self.self).url(forResource: "Deck", withExtension:"momd") else {
      fatalError("Failed to get core data model url")
    }
    guard let objectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Failed to create object model at url: \(modelURL)")
    }
    let container = NSPersistentContainer(name: "Deck", managedObjectModel: objectModel)
    // load persistent store
    container.loadPersistentStores { _, error in
      guard let error = error else { return }
      fatalError("Unresolved DB error \(error)")
    }
    return container
  }()
  
  private lazy var dbContext: NSManagedObjectContext = {
    persistentContainer.viewContext
  }()
  
  private func saveContext () {
    guard dbContext.hasChanges else { return }
    do {
      try dbContext.save()
    } catch {
      fatalError("Save DB context error \(error)")
    }
  }
}

