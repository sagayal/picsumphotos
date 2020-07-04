//
//  ErrorFactory.swift
//  PicsumPreview
//
//  Created by Martin on 01/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

// MARK: - ErrorFactory
enum ErrorFactory: Int {
  case unknownAPIResponse = -501
  case generic
  case invalidResponse
  case jsonSerialization
  case invalidURL
  case networkNotReachable

  func error() -> NSError {
    switch self {
    case .unknownAPIResponse:
      return NSError(domain: "com.sls.api", code: ErrorFactory.unknownAPIResponse.rawValue, userInfo: nil)
    case .generic:
      return NSError(domain: "com.sls.generic", code: ErrorFactory.generic.rawValue, userInfo: nil)
    case .invalidResponse:
      return NSError(domain: "com.sls.response", code: ErrorFactory.invalidResponse.rawValue, userInfo: nil)
    case .jsonSerialization:
      return NSError(domain: "com.sls.json", code: ErrorFactory.jsonSerialization.rawValue, userInfo: nil)
    case .invalidURL:
      return NSError(domain: "com.sls.url", code: ErrorFactory.invalidURL.rawValue, userInfo: nil)
    case .networkNotReachable:
      return NSError(domain: "com.sls.network", code: ErrorFactory.networkNotReachable.rawValue, userInfo: nil)
    }
  }
}
