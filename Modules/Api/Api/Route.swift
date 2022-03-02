//
//  Route.swift
//  Api
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import Foundation

public enum Route {
  case createDeck
  case getHand(deckId: String)
  case reshuffle(deckId: String)
  
  internal static let host = URL(string: "https://deckofcardsapi.com")
  
  internal var path: String {
    switch self {
    case .createDeck: return "/api/deck/new/shuffle"
    case .getHand(let deckId): return "/api/deck/\(deckId)/draw"
    case .reshuffle(let deckId): return "/api/deck/\(deckId)/shuffle"
    }
  }
}
