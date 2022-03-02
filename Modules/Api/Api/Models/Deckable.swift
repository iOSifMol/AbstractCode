//
//  Deckable.swift
//  Api
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation

public protocol Deckable: Codable {
  var deckId: String { get set }
  var remaining: Int { get set }
  var shuffled: Bool { get set }
}
