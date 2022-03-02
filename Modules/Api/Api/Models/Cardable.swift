//
//  Cardable.swift
//  Api
//
//  Created by Iosif Moldovan on 02.03.2022.
//

import Foundation

public protocol Cardable: Codable {
  var code: String { get set }
  var value: String { get set }
  var suit: String { get set }
  var image: String { get set }
}
