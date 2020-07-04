//
//  PicsumImageViewModel.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

public struct PicsumImageViewModel {
  // MARK: - Properties
  private let picsumImageModels: [PicsumImageModel]
  private let authors: [String]

  // MARK: - Intializer
  init(_ picsumImageModels: [PicsumImageModel]) {
    self.picsumImageModels = picsumImageModels
    authors = Array(Set(picsumImageModels.compactMap { $0.author })).sorted()
  }

  // MARK: - Helper methods
  func pictureCount(author: String?) -> Int {
    guard let author = author else { return 0 }
    return picsumImageModels.filter({ $0.author == author }).count
  }

  func picsumImageIdFor(indexPath: IndexPath) -> Int? {
    guard let imageModels = picsumImagesFor(author: authors[indexPath.section]) else { return nil }
    return imageModels[indexPath.row].identifier
  }

  func author(of index: Int) -> String? {
    guard authors.count >= index else { return nil }
    return authors[index]
  }

  func authorCount() -> Int {
    return authors.count
  }

  private func picsumImagesFor(author: String?) -> [PicsumImageModel]? {
    guard let author = author else { return nil }
    return self.picsumImageModels.filter { $0.author == author }
  }
}
