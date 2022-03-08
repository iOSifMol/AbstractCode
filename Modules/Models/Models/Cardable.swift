//
//  Cardable.swift
//  Api
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation
import CoreData

public protocol Cardable: Codable {
  var code: String { get set }
  var value: String { get set }
  var suit: String { get set }
  var image: String { get set }
  init(code: String, value: String, suit: String, image: String)
}

public extension Cardable {
  var imageURL: URL {
    guard let url = URL(string: image) else {
      fatalError("Failed compute image url from: \(image)")
    }
    return url
  }
}
