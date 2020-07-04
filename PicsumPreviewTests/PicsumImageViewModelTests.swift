//
//  PicsumImageViewModelTests.swift
//  PicsumPreviewTests
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import XCTest
@testable import PicsumPreview

class PicsumImageViewModelTests: XCTestCase {
  var picsumImageViewModel: PicsumImageViewModel?

  override func setUpWithError() throws {
    let picsumImagesResponse = JsonUtility.jsonToPicsumImageModels(fromFile: "PhotList", for: PicsumImageCollectionViewControllerTests.self)
    picsumImageViewModel = PicsumImageViewModel(picsumImagesResponse)
  }

  func testPictureCount() throws {
    let picutureCount = try XCTUnwrap(picsumImageViewModel?.pictureCount(author: "Alejandro Escamilla"))
    XCTAssertEqual(picutureCount, 2)
  }

  func testPicsumImageIdFor() throws {
    let imageId = try XCTUnwrap( picsumImageViewModel?.picsumImageIdFor(indexPath: IndexPath(row: 0, section: 0)))
    XCTAssertEqual(imageId, 1020)
  }

  func testAuthorOfIndex() throws {
    let author = try XCTUnwrap( picsumImageViewModel?.author(of: 0))
    XCTAssertEqual(author, "Adam Willoughby-Knox")
  }

  func testAuthorCount() throws {
    let authorCount = try XCTUnwrap( picsumImageViewModel?.authorCount())
    XCTAssertEqual(authorCount, 44)
  }

  override func tearDownWithError() throws {
    picsumImageViewModel = nil
  }
}
