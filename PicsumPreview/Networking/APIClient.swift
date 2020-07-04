//
//  PicsumAPIClient.swift
//  PicsumPreview
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

// MARK: - Callback typealias
public typealias FailureCallback = (_ error: NSError) -> Void
public typealias SuccessArrayCallback = ([[String: Any]]) -> Void

// MARK: - Response typealias
public typealias ApiSuccessResponse = [[String: Any]]
public typealias ApiFailureResponse = NSError

class APIClient {
  var successResponse: ApiSuccessResponse?
  var failureResponse: ApiFailureResponse?
  // Default implementation for APIClient, needs to be overridden by the derived class for downloading the image list
  func imageList(successArray: @escaping SuccessArrayCallback, failure: @escaping FailureCallback) {
    DispatchQueue.global().async {
      if let successResponse = self.successResponse {
          DispatchQueue.main.async { successArray(successResponse) }
      } else if let failureResponse = self.failureResponse {
          DispatchQueue.main.async { failure(failureResponse) }
      } else {
        DispatchQueue.main.async { failure(NSError()) }
      }
    }
  }
}
