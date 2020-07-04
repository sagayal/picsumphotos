//
//  ColumnFlowLayout.swift
//  PicsumPreview
//
//  Created by Martin on 30/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
  // MARK: - Constants
  private static let minColumnWidth = CGFloat(200.0)
  private static let cellHeight = CGFloat(300.0)
  private static let headerHeight = CGFloat(50.0)
  private static let edgeInset = CGFloat(10.0)

  // MARK: - Collection View Flow Layout overrides
  override func prepare() {
    super.prepare()
    guard let collectionView = self.collectionView else { return }

    sectionInset = UIEdgeInsets(top: ColumnFlowLayout.edgeInset,
                                left: ColumnFlowLayout.edgeInset,
                                bottom: ColumnFlowLayout.edgeInset,
                                right: ColumnFlowLayout.edgeInset)
    sectionInsetReference = .fromSafeArea
    // Makes header sticky
    sectionHeadersPinToVisibleBounds = true

    // Calculate collectionView avaialable view width
    let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).size.width
    headerReferenceSize = CGSize(width: availableWidth, height: ColumnFlowLayout.headerHeight)

    // Calculate width for each column based on available width
    let maxNumberOfColumns = availableWidth / ColumnFlowLayout.minColumnWidth
    let cellWidth = (availableWidth / CGFloat(maxNumberOfColumns)).rounded(.down)

    itemSize = CGSize(width: cellWidth, height: ColumnFlowLayout.cellHeight)
  }
}
