//
//  ViewModel.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 01.03.2022.
//

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
