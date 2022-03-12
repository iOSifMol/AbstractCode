// MIT License
//
// Copyright (c) 2022 Iosif
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

