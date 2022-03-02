//
//  Deck.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation
import Api

struct Deck: Deckable {
  var deckId: String
  var remaining: Int
  var shuffled: Bool
}
