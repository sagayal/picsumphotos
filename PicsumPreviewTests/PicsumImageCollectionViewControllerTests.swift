//
//  PicsumPreviewTests.swift
//  PicsumPreviewTests
//
//  Created by Martin on 25/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import XCTest
import Kingfisher
@testable import PicsumPreview

class PicsumImageCollectionViewControllerTests: XCTestCase {
  var viewController: PicsumImageCollectionViewController?

  override func setUpWithError() throws {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    viewController = storyboard.instantiateViewController(withIdentifier: "PicsumImageCollectionViewController") as? PicsumImageCollectionViewController
    try setUpCache()
    let picsumImagesResponse = JsonUtility.jsonToPicsumImageModels(fromFile: "PhotList", for: PicsumImageCollectionViewControllerTests.self)
    viewController?.collectionViewDataSource.configure(picsumImageModels: picsumImagesResponse)
    viewController?.loadView()
    viewController?.viewDidLoad()
  }

  override func tearDownWithError() throws {
    ImageCache.default.clearDiskCache()
    ImageCache.default.clearMemoryCache()
    viewController = nil
  }

  func setUpCache() throws {
    let image = try XCTUnwrap(UIImage(named: "PicsumLaunch"))
    var cacheImageURL = try XCTUnwrap(URL(string: "https://picsum.photos/200/300?image=0"))
    ImageCache.default.store(image, forKey: cacheImageURL.absoluteString)
    cacheImageURL = try XCTUnwrap(URL(string: "https://unsplash.com/photos/200/300??image=1015"))
    ImageCache.default.store(image, forKey: cacheImageURL.absoluteString)
  }

  func testNumberOfPicsumCellItems() throws {
    let collectionView = try XCTUnwrap(viewController?.collectionView)
    let itemsInSection = try XCTUnwrap(viewController?.collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: 0))
    XCTAssertEqual(itemsInSection, 1)
  }

  func testCellItem() throws {
    let collectionView = try XCTUnwrap(viewController?.collectionView)
    let cellIem = try XCTUnwrap(viewController?.collectionViewDataSource.collectionView(collectionView,

                                                                                        cellForItemAt: IndexPath(row: 0, section: 0))) as? PicsumImageViewCell
    XCTAssertNotNil(cellIem)
    var imageConfigureExpectation = expectation(description: "Image configure success")
    cellIem?.configure(imageId: "0", success: {
      imageConfigureExpectation.fulfill()
    })
    waitForExpectations(timeout: 5, handler: nil)

    imageConfigureExpectation = expectation(description: "Image configure failure")
    cellIem?.configure(imageId: "^^^", failure: {
      imageConfigureExpectation.fulfill()
    })
    waitForExpectations(timeout: 5, handler: nil)

    XCTAssertNotNil(cellIem?.picture)
  }

  func testRefreshController() throws {
    let picsumViewControler = try XCTUnwrap(viewController)
    picsumViewControler.startRefresh()
    picsumViewControler.endRefresh()
    picsumViewControler.relaodImageList()
  }

  func testHandleParseErrorSuccess() throws {
    viewController?.handleParseError {
      let picsumImageModels = JsonUtility.jsonToPicsumImageModels(fromFile: "PhotList", for: PicsumImageCollectionViewControllerTests.self)
      XCTAssertEqual(picsumImageModels.count, 47)
    }
  }

  func testHandleParseErrorFailure() throws {
    viewController?.handleParseError {
      let picsumImageModels = try JSONDecoder().decode([PicsumImageModel].self, from: Data())
      XCTAssertNil(picsumImageModels)
    }
  }

  func testHandleFailure() throws {
    var alert: UIAlertController?
    alert = AlertView.create(for: ErrorFactory.unknownAPIResponse.error())
    XCTAssertEqual(alert?.title, "Error Occured")
    XCTAssertEqual(alert?.actions.first?.title, "Ok")
    XCTAssertEqual(alert?.message, "Server not responding please try again later")

    alert = AlertView.create(for: ErrorFactory.generic.error())
    XCTAssertEqual(alert?.message, "Something went wrong try again later")

    alert = AlertView.create(for: ErrorFactory.invalidResponse.error())
    XCTAssertEqual(alert?.message, "Invalid response please try again later")

    alert = AlertView.create(for: ErrorFactory.jsonSerialization.error())
    XCTAssertEqual(alert?.message, "Invalid response please try again later")

    alert = AlertView.create(for: ErrorFactory.invalidURL.error())
    XCTAssertEqual(alert?.message, "Something went wrong try again later")

    alert = AlertView.create(for: ErrorFactory.networkNotReachable.error())
    XCTAssertEqual(alert?.message, "Network is down try again later")
  }
}
