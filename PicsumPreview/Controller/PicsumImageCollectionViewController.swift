//
//  PicsumImageCollectionViewController.swift
//  PicsumPreview
//
//  Created by Martin on 27/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit

class PicsumImageCollectionViewController: UICollectionViewController {
  // MARK: - Properties
  var collectionViewDataSource = PicsumImageCollectionViewDataSource()
  private var picSumAPIService: APIClient?
  private let refreshControll = UIRefreshControl()

  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    loadImages()
  }

  // MARK: - View life cycle Helpers
  func configure(picSumAPIService: APIClient = PicsumAPIClient()) {
    self.picSumAPIService = picSumAPIService
    collectionView.dataSource = collectionViewDataSource
    title = NSLocalizedString("View.Title", comment: "")
    collectionView.collectionViewLayout = ColumnFlowLayout()
    configureRefreshButton()
    configureRefreshController()
  }
}

// MARK: - PicSumAPIService helpers
extension PicsumImageCollectionViewController {
  func loadImages(isRefreshing: Bool = false, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
    DLog.print("Load Image List")
    isRefreshing ? refreshControll.beginRefreshing() : LoadingAlertView.show()
    picSumAPIService?.imageList(
      successArray: { [weak self] (response) in
        guard let self = self else { return }

        // Parse response and transform to PicsumImageViewModel
        self.handleParseError { [weak self] in
          DLog.print("Parsing Response")
          let json = try JSONSerialization.data(withJSONObject: response, options: [])
          let picsumImagesResponse = try JSONDecoder().decode([PicsumImageModel].self, from: json)
          self?.collectionViewDataSource.configure(picsumImageModels: picsumImagesResponse)
        }

        isRefreshing ? self.endRefresh() : LoadingAlertView.hide()
        self.collectionView.reloadData()
        success?()
      },
      failure: { [weak self] (error) in
        isRefreshing ? self?.endRefresh() : LoadingAlertView.hide()
        DLog.print("API response Error: \(error)")
        self?.showAlert(for: error)
        failure?()
    })
  }

  func handleParseError(for parseTask: (() throws -> Void)) {
    do {
      try parseTask()
    } catch let error {
      DLog.print(error)
      showAlert()
    }
  }

  func showAlert(for error: NSError? = nil) {
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.isScrollEnabled = false
      self?.present( AlertView.create(), animated: false) {
        DispatchQueue.main.async { [weak self] in self?.collectionView.isScrollEnabled = true }
      }
    }
  }
}

// MARK: - Refresh controll
extension PicsumImageCollectionViewController {
  func configureRefreshController() {
    refreshControll.tintColor = .green
    refreshControll.attributedTitle = NSAttributedString(string: NSLocalizedString("RefreshControl.Label.text", comment: ""))
    refreshControll.addTarget(self, action: #selector(startRefresh), for: UIControl.Event.valueChanged)
    collectionView.addSubview(refreshControll)
  }

  @objc func startRefresh() {
    DLog.print("Pulled to refresh Image List")
    collectionView.isScrollEnabled = false
    loadImages(isRefreshing: true)
  }

  @objc func relaodImageList() {
    DLog.print("Reload Image List")
    loadImages()
  }

  func endRefresh() {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) { [weak self] in
      self?.refreshControll.endRefreshing()
      self?.collectionView.isScrollEnabled = true
    }
  }
}

extension PicsumImageCollectionViewController {
  func configureRefreshButton() {
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(relaodImageList))
    navigationItem.rightBarButtonItems = [refresh]
  }
}
