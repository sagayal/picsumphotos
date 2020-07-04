//
//  AlertView.swift
//  PicsumPreview
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import UIKit

class AlertView {
  // MARK: - Create Alert
  class func create(for error: NSError? = nil) -> UIAlertController {
    let okActionText = NSLocalizedString("ErrorAlert.Ok", comment: "")
    var message = NSLocalizedString("ErrorAlert.Message.Generic", comment: "")
    if let errorCode = ErrorFactory(rawValue: error?.code ?? 0) {
      switch errorCode {
      case .unknownAPIResponse:
        message = NSLocalizedString("ErrorAlert.Message.UnknownAPIResponse", comment: "")
      case .generic:
        message = NSLocalizedString("ErrorAlert.Message.Generic", comment: "")
      case .invalidResponse:
        message = NSLocalizedString("ErrorAlert.Message.InvalidResponse", comment: "")
      case .jsonSerialization:
        message = NSLocalizedString("ErrorAlert.Message.JsonSerialization", comment: "")
      case .invalidURL:
        message = NSLocalizedString("ErrorAlert.Message.InvalidURL", comment: "")
      case .networkNotReachable:
        message = NSLocalizedString("ErrorAlert.Message.NetworkNotReachable", comment: "")
      }
    }

    let alertController = UIAlertController(title: NSLocalizedString("ErrorAlert.Title", comment: ""),
                                            message: message,
                                            preferredStyle: .alert)
    let okAction = UIAlertAction(title: okActionText, style: .default)
    alertController.addAction(okAction)
    return alertController
  }
}
