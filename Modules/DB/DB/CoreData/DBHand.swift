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
