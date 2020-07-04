//
//  ImageCacher.swift
//  PicsumPreview
//
//  Created by Martin on 30/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Kingfisher

public final class ImageCacher {
  static let sharedInstance = ImageCacher()

  private init() {
    ImageCache.default.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
    ImageCache.default.diskStorage.config.sizeLimit  = 500 * 1024 * 1024
  }

  // MARK: - ImageCache Helper
  func loadImage(forKey cacheKey: String, completionHandler: CompletionHandler? = nil) {
    ImageCache.default.retrieveImage(forKey: cacheKey) { result in
      switch result {
      case .success(let imageResult):
        DLog.print("Image Retrieved from cache - Success")
        completionHandler?(imageResult.image, nil)

      case .failure(let error):
        completionHandler?(nil, error)
      }
    }
  }
}
