//
//  ViewModel.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import Foundation
import Api
import DB

// Deck id: bdtcvsug96ba
final class ViewModel: ObservableObject {
  let api: DeckApi
  let db: DeckDB
  
  init() {
    api = DeckApi()
    db = DeckDB()
    testRequest()
  }
  
  func testRequest() {
    let t = db.getStoredHand(Hand.self)
    print("Stored card: \(t)")
    
//    api.perform(.createDeck, output: Deck.self) { result in
//      switch result {
//      case .success(let deck):
//        print("Success: deck: \(deck)")
//      case .failure(let error):
//        print("Error: \(error)")
//      }
//    }
    
    api.perform(.getHand(deckId: "bdtcvsug96ba"), output: Hand.self) { [weak self] result in
      switch result {
      case .success(let hand):
        print("Success: hand \(hand)")
        self?.db.deleteAllHands()
        self?.db.save(hand: hand)
      case .failure(let error):
        print("Error: \(error)")
      }
    }
    
//    api.perform(.reshuffle(deckId: "bdtcvsug96ba"), output: Deck.self) { result in
//      switch result {
//      case .success(let deck):
//        print("Success: deck \(deck)")
//      case .failure(let error):
//        print("Error: \(error)")
//      }
//    }
    
  }
}
