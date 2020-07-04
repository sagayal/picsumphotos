//
//  PicsumAPIQueryService.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

class PicsumAPIService {

  public typealias FailureCallback = (_ error: NSError) -> Void
  public typealias SuccessArrayCallback = ([[String: Any]]) -> Void

  enum APIError: Swift.Error {
    case unknownAPIResponse
    case generic
    case jsonSerialization
    case invalidURL
  }

  func imageList(successArray: @escaping SuccessArrayCallback, failure: @escaping FailureCallback) {
    guard let imageListURL = URL(string: "https://picsum.photos/list") else {
      // invalidURL
      failure(NSError())
      return
    }
    let imageListRequest = URLRequest(url: imageListURL)

    let imageListTask = URLSession.shared.dataTask(with: imageListRequest) { (data, response, error) in
      if let error = error {
        DispatchQueue.main.async {
          print("error: \(error)")
          // Error generic
          failure(NSError())
        }
        return
      }
      guard
        (response as? HTTPURLResponse) != nil,
        let validData = data, validData.count > 0
        else {
          DispatchQueue.main.async {
            // error unknownAPIResponse
            print("error: Data error")
            failure(NSError())
          }
          return
      }
      do {
        let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments) as? [[String: Any]] ?? []
        print("Result: \(json)")
        DispatchQueue.main.async {
          successArray(json)
        }
//          return .success(plist)
        return
      } catch {
//          return .failure(AFError.responseSerializationFailed(reason: .propertyListSerializationFailed(error: error)))
        return
      }
    }
    imageListTask.resume()
  }
}
