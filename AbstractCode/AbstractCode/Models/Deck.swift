//
//  Deck.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation
import Models

struct Deck: Deckable {
  var deckId: String
  var remaining: Int
  var shuffled: Bool
}
