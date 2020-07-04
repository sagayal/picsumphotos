//
//  PicsumAPIServiceTests.swift
//  PicsumPreviewTests
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import XCTest
import Kingfisher
@testable import PicsumPreview

class PicsumAPIServiceTests: XCTestCase {
  var mockAPIService: APIClient?
  var viewController: PicsumImageCollectionViewController?

  override func setUpWithError() throws {
    mockAPIService = APIClient()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    viewController = storyboard.instantiateViewController(withIdentifier: "PicsumImageCollectionViewController") as? PicsumImageCollectionViewController
    viewController?.loadView()
    viewController?.viewDidLoad()
  }

  override func tearDownWithError() throws {
    mockAPIService = nil
  }

  func testPicsumAPIMockServiceSuccess() throws {
    let apiService = try XCTUnwrap(mockAPIService)
    viewController?.configure(picSumAPIService: apiService)
    mockAPIService?.successResponse = JsonUtility.jsonToDictionaryArrayFromFile("PhotList", for: PicsumImageCollectionViewControllerTests.self)
    mockAPIService?.failureResponse = nil
    let successResponseExpectation =  expectation(description: "PicsumService Success")
    viewController?.loadImages(isRefreshing: false, success: {
      XCTAssert(true, "Success Response")
      successResponseExpectation.fulfill()
    }, failure: {
      XCTAssert(false, "Failure occured when success is expected")
      successResponseExpectation.fulfill()
    })
    waitForExpectations(timeout: 5, handler: nil)
  }

  func testPicsumAPIMockServiceFailure() throws {
    let apiService = try XCTUnwrap(mockAPIService)
    viewController?.configure(picSumAPIService: apiService)
    mockAPIService?.successResponse = nil
    mockAPIService?.failureResponse = ErrorFactory.generic.error()
    let failureResponseExpectation =  expectation(description: "PicsumService Failure")
    viewController?.loadImages(isRefreshing: false, success: {
      XCTAssert(false, "Success is not expected")
      failureResponseExpectation.fulfill()
    }, failure: {
      XCTAssert(true, "Failure Response")
      failureResponseExpectation.fulfill()
    })
    waitForExpectations(timeout: 5, handler: nil)
  }

  func testImageCacher() throws {
    let image = try XCTUnwrap(UIImage(named: "PicsumLaunch"))
    ImageCache.default.store(image, forKey: "PicsumLaunch")
    let imageCacherExpectation = expectation(description: "Image cacher success")
    ImageCacher.sharedInstance.loadImage(forKey: "PicsumLaunch") { (storedImage, error) in
      XCTAssertNotNil(storedImage)
      XCTAssertNil(error)
      imageCacherExpectation.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
    ImageCache.default.clearDiskCache()
    ImageCache.default.clearMemoryCache()
  }
}
