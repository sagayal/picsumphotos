//
//  PicsumImageExtensionTests.swift
//  PicsumPreviewTests
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import XCTest
import Kingfisher
@testable import PicsumPreview

class PicsumImageExtensionTests: XCTestCase {

  func testImageFromURL() throws {
    let imageView = UIImageView()
    let imageResponseExpectation =  expectation(description: "Image from url test")
    imageView.setImageFor(url: URL(string: "")) { (_, error) in
      XCTAssertNotNil(error)
      imageResponseExpectation.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
}
