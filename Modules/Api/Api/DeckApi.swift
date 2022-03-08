//
//  DeckApi.swift
//  Api
//
//  Created by Iosif Moldovan on 01.03.2022.
//

import Foundation

public struct DeckApi {
  public init() {}
  
  public func perform<Model: Codable>(_ route: Route,
                                      output: Model.Type,
                                      completion: @escaping (_ result: Result<Model, Error>) -> Void) {
    guard let url = URL(string: route.path, relativeTo: Route.host) else {
      fatalError("Failed to create url for route: \(route)")
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        let httpResponse = response as? HTTPURLResponse
        guard error == nil, httpResponse?.statusCode == 200, let data = data else {
          let genericError = NSError(domain: "api.error.unknown", code: -324)
          completion(.failure(error ?? genericError))
          return
        }
        parseResponse(data: data, completion: completion)
      }
    }.resume()
  }
  
  private func parseResponse<Model: Codable>(data: Data,
                                             completion: @escaping (_ result: Result<Model, Error>) -> Void) {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let model = try decoder.decode(Model.self, from: data)
      completion(.success(model))
    } catch {
      completion(.failure(error))
    }
  }
}
