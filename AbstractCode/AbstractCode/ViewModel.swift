//
//  ViewModel.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import Foundation
import Api

// Deck id: bdtcvsug96ba
final class ViewModel: ObservableObject {
  let api: DeckApi
  
  init() {
    api = DeckApi()
    testRequest()
  }
  
  func testRequest() {
//    api.perform(.createDeck, output: Deck.self) { result in
//      switch result {
//      case .success(let deck):
//        print("Success: deck: \(deck)")
//      case .failure(let error):
//        print("Error: \(error)")
//      }
//    }
    
    api.perform(.getHand(deckId: "bdtcvsug96ba"), output: Hand.self) { result in
      switch result {
      case .success(let deck):
        print("Success: hand \(deck)")
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
