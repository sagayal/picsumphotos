//
//  PicsumImageViewCell.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit

class PicsumImageViewCell: UICollectionViewCell {
  // MARK: - IBOutlets
  @IBOutlet weak var picture: UIImageView!

  // MARK: - Configure Image view cell
  func configure(imageId: String, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
    picture.setImageFor(url: URL(string: String(format: Environment.photoURL, imageId))) { [weak self] (image, _) in
      if let image = image {
        self?.picture.image = image.withRenderingMode(.alwaysOriginal)
        success?()
      } else {
        self?.picture.image = UIImage(named: "placeholderimage")
        failure?()
      }
    }
  }
}
