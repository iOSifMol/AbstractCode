// MIT License
//
// Copyright (c) 2022 Iosif
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

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
  
  public func getImage(from url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        let httpResponse = response as? HTTPURLResponse
        guard httpResponse?.statusCode == 200, error == nil, let imageData = data else {
          completion(nil)
          return
        }
        completion(UIImage(data: imageData))
      }
    }.resume()
  }
  
  // MARK: - Helpers Methods
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
