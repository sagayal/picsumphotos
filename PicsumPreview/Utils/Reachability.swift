//
//  Reachability.swift
//  PicsumPreview
//
//  Created by Martin on 01/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import SystemConfiguration

// MARK: - Reachability helpers
//
//     checks network reachability status based on the url passed in SCNetworkReachabilityCreateWithName method
//     - returns Bool status of reachable flag
//
final class NetworkEnvironment {
  class func isReachable() -> Bool {
    guard let reachability = SCNetworkReachabilityCreateWithName(nil, Environment.baseURL) else {
      return false
    }

    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability, &flags)
    return flags.contains(.reachable)
  }
}
