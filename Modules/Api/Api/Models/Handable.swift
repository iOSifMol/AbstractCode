//
//  Handable.swift
//  Api
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation

public protocol Handable: Codable {
  associatedtype Card: Cardable
  var deckId: String { get set }
  var remaining: Int { get set }
  var cards: [Card] { get set }
}
