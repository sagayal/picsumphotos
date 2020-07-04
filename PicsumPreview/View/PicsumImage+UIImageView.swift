//
//  ImageFromURL.swift
//  PicsumPreview
//
//  Created by Martin on 29/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Kingfisher

// MARK: - compeletion handler typealias
public typealias CompletionHandler = (_ image: UIImage?, _ error: Error?) -> Void

extension UIImageView {
  // MARK: - Image download helper
  public func setImageFor(url: URL?, completionHandler: CompletionHandler? = nil) {
    guard let url = url else {
      DLog.print("Ivalid photo URL")
      completionHandler?(nil, ErrorFactory.invalidURL.error())
      return
    }

    if ImageCache.default.isCached(forKey: url.absoluteString) {
      DLog.print("Photo in cache: Retrieve from cache: \(url)")
      ImageCacher.sharedInstance.loadImage(forKey: url.absoluteString) {[weak self] (imageResult, error) in
        guard error != nil else {
          completionHandler?(imageResult, nil)
          return
        }
        DLog.print("Retrieve from cache failed - Download: \(url)")
        self?.downloadImage(url: url) { (imageResult, error) in
          completionHandler?(imageResult, error)
        }
      }
    } else {
      DLog.print("Photo not in cache: Download: \(url)")
      downloadImage(url: url) { (imageResult, error) in
        completionHandler?(imageResult, error)
      }
    }
  }

  private func downloadImage(url: URL, completionHandler: CompletionHandler? = nil) {
    guard NetworkEnvironment.isReachable() else {
      DispatchQueue.main.async { completionHandler?(nil, ErrorFactory.networkNotReachable.error()) }
      return
    }
    let imageResource = ImageResource(downloadURL: url)
    kf.indicatorType = .activity
    kf.setImage(with: imageResource) { result in
      switch result {
      case .success(let imageResult):
        DLog.print("Photo Download Success: \(url.absoluteString)")
        ImageCache.default.store(imageResult.image, forKey: url.absoluteString)
        completionHandler?(imageResult.image, nil)

      case .failure(let error):
        DLog.print("Photo Download Failed: \(url.absoluteString)")
        ImageCache.default.removeImage(forKey: url.absoluteString)
        completionHandler?(nil, error)
      }
    }
  }
}
