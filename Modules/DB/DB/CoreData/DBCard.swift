//
//  DBCard.swift
//  DB
//
//  Created by Iosif Moldovan on 07.03.2022.
//

import Foundation
import CoreData
import Models

class DBCard: NSManagedObject {
  @NSManaged var code: String
  @NSManaged var value: String
  @NSManaged var suit: String
  @NSManaged var image: String
}

extension DBCard {
  func cardable<Card: Cardable>() -> Card {
    Card(code: code, value: value, suit: suit, image: image)
  }
  
  @discardableResult
  static func create<Card: Cardable>(from card: Card, in context: NSManagedObjectContext) -> DBCard {
    let dbCard = DBCard(context: context)
    dbCard.code = card.code
    dbCard.value = card.value
    dbCard.suit = card.suit
    dbCard.image = card.image
    return dbCard
  }
}
