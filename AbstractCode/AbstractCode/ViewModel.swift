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
import UIKit
import Api
import DB

enum State {
  case fetching               // fetching a new hand from api
  case playing(hand: Hand)    // playing the hand
  case error(message: String) // api error
}

final class ViewModel: ObservableObject {
  private let api: DeckApi
  private let db: DeckDB
  private var deckId: String?
  @Published var state: State = .fetching
  @Published var cardImage: UIImage = UIImage(named: "empty_card")!
  
  init() {
    api = DeckApi()
    db = DeckDB()
    initState()
  }
  
  // MARK: - Public Methods
  func getNewHand() {
    guard let deckId = deckId else {
      state = .error(message: "Failed get deck")
      return
    }
    state = .fetching
    print("Prepare to get new hand")
    api.perform(.getHand(deckId: deckId), output: Hand.self) { [weak self] result in
      switch result {
      case .success(let hand):
        print("Did succeed to get new hand: \(hand)")
        self?.db.deleteAllHands()
        self?.db.save(hand: hand)
        self?.state = .playing(hand: hand)
        self?.getImage(for: hand.cards.first)
      case .failure(let error):
        self?.state = .error(message: error.localizedDescription)
      }
    }
  }
  
  func reshuffleDeck() {
    guard let deckId = deckId else {
      state = .error(message: "Failed get deck")
      return
    }
    getDeck(id: deckId)
  }
  
  // MARK: - Helper Methods
  private func initState() {
    guard let storedHand = db.getStoredHand(Hand.self) else {
      getDeck()
      return
    }
    deckId = storedHand.deckId
    state = .playing(hand: storedHand)
    getImage(for: storedHand.cards.first)
  }
  
  // reshuffle and get new deck are very much a like, both routes return the same response: a deck
  private func getDeck(id: String? = nil) {
    state = .fetching
    var route: Route = .createDeck
    if let deckId = id {
      route = .reshuffle(deckId: deckId)
    }
    print("Prepare deck")
    api.perform(route, output: Deck.self) { [weak self] result in
      switch result {
      case .success(let deck):
        self?.deckId = deck.deckId
        self?.getNewHand()
      case .failure(let error):
        self?.state = .error(message: error.localizedDescription)
      }
    }
  }

  private func getImage(for card: Card?) {
    guard let card = card else { return }
    api.getImage(from: card.imageURL) { [weak self] image in
      self?.cardImage = image ?? UIImage(named: "empty_card")!
    }
  }
}
