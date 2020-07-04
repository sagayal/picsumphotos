//
//  PicsumImageCollectionViewDataSource.swift
//  PicsumPreview
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit

class PicsumImageCollectionViewDataSource: NSObject, UICollectionViewDataSource {
  // MARK: - Properties
  private var picsumImageViewModel: PicsumImageViewModel?

  // MARK: - Configure
  func configure(picsumImageModels: [PicsumImageModel]) {
    picsumImageViewModel = PicsumImageViewModel(picsumImageModels)
  }

  // MARK: - UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return picsumImageViewModel?.authorCount() ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return picsumImageViewModel?.pictureCount(author: picsumImageViewModel?.author(of: section)) ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? PicsumImageViewCell,
      let sectionImageId = picsumImageViewModel?.picsumImageIdFor(indexPath: indexPath) else {
        return UICollectionViewCell()
    }
    cell.configure(imageId: "\(sectionImageId)")
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "SectionHeaderView",
                                                                             for: indexPath) as? SectionHeaderView else {
                                                                              fatalError("Invalid headerView")
      }
      headerView.title.text = picsumImageViewModel?.author(of: indexPath.section)?.capitalized
      return headerView
    default:
      fatalError("Unexpected element kind")
    }
  }
}
