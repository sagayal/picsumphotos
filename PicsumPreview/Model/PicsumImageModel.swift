//
//  PicsumImage.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

struct PicsumImageModel: Decodable {
  // MARK: - Properties
  let identifier: Int
  let author: String

  // MARK: - CodingKeys
  private enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case author
  }
}
