//
//  PicsumAPIQueryService.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

class PicsumAPIClient: APIClient {
  // MARK: - Properties
  private let defaultSession = URLSession(configuration: .default)
  private var dataTask: URLSessionDataTask?

  // MARK: - API - imageList data task
  override func imageList(successArray: @escaping SuccessArrayCallback, failure: @escaping FailureCallback) {
    guard NetworkEnvironment.isReachable() else {
      DispatchQueue.main.async { failure(ErrorFactory.generic.error()) }
      return
    }
    guard let imageListURL = URL(string: Environment.photoListURL) else {
      DispatchQueue.main.async { failure(ErrorFactory.invalidURL.error()) }
      return
    }

    // Cancel existing if any before starting a new data task
    dataTask?.cancel()

    dataTask = defaultSession.dataTask(with: URLRequest(url: imageListURL)) { [weak self](data, response, error) in
      defer { self?.dataTask = nil }

      if let error = error {
        DLog.print("Image list data task API error: \(error)")
        DispatchQueue.main.async { failure(ErrorFactory.generic.error()) }
        return
      }

      guard response as? HTTPURLResponse != nil,
        let validData = data, validData.count > 0 else {
          DLog.print("Image list invalid data")
          DispatchQueue.main.async { failure(ErrorFactory.invalidResponse.error()) }
          return
      }

      do {
        let json = try JSONSerialization.jsonObject(with: validData, options: .allowFragments) as? [[String: Any]] ?? []
        DLog.print("Response Jon: \(json)")
        DispatchQueue.main.async { successArray(json) }
      } catch let error {
        DLog.print(error)
        DispatchQueue.main.async { failure(ErrorFactory.jsonSerialization.error()) }
      }
    }
    dataTask?.resume()
  }
}
