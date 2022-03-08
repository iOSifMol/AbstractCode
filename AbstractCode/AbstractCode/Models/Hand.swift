//
//  Hand.swift
//  AbstractCode
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation
import Models

struct Hand: Handable {
  var deckId: String
  var remaining: Int
  var cards: [Card]
}
