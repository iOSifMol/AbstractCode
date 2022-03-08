//
//  DBHand.swift
//  DB
//
//  Created by Iosif Moldovan on 07.03.2022.
//

import Foundation
import CoreData
import Models

class DBHand: NSManagedObject {
  @NSManaged var deckId: String
  @NSManaged var remaining: Int
  @NSManaged var dbCards: Set<DBCard>
  var cards: [DBCard] {
    get { dbCards.map({ $0} ) }
    set { newValue.forEach({ dbCards.insert($0) })
    }
  }
}

extension DBHand {
  func handable<Hand: Handable>() -> Hand {
    Hand(deckId: deckId, remaining: remaining, cards: cards.map({ $0.cardable() }) )
  }
  
  @discardableResult
  static func create<Hand: Handable>(from hand: Hand, in context: NSManagedObjectContext) -> DBHand {
    let dbHand = DBHand(context: context)
    dbHand.deckId = hand.deckId
    dbHand.remaining = hand.remaining
    dbHand.cards = hand.cards.map({ DBCard.create(from: $0, in: context) })
    
    return dbHand
  }
}
