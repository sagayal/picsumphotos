//
//  LoadingAlertView.swift
//  PicsumPreview
//
//  Created by Martin on 30/06/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit
import Lottie

class LoadingAlertView: UIView {
  // MARK: - IBOutlet
  @IBOutlet weak var animationView: AnimationView!
  // MARK: - Constants
  static let animationSource = "loading-polichat"
  static var loadingAlertView: LoadingAlertView?

  // MARK: - Configure view
  func configure() {
    frame = UIScreen.main.bounds
    let startAnimation =   Animation.named(LoadingAlertView.animationSource)
    animationView.animation = startAnimation
    animationView.loopMode = .loop
    animationView.play()
  }

  // MARK: - Helpers
  class func show() {
    if LoadingAlertView.loadingAlertView == nil {
      LoadingAlertView.loadingAlertView = Bundle.main.loadNibNamed("LoadingAlertView", owner: self, options: nil)?.first as? LoadingAlertView
      guard let loadingAlertView = LoadingAlertView.loadingAlertView else { return }
      loadingAlertView.configure()
      UIApplication.shared.keyWindow?.addSubview(loadingAlertView)
    }
  }

  class func hide() {
    loadingAlertView?.removeFromSuperview()
    loadingAlertView = nil
  }
}
