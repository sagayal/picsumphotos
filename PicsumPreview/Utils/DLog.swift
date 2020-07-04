//
//  DLog.swift
//  PicsumPreview
//
//  Created by Martin on 01/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

public struct DLog {
  // MARK: - Debug Log helper

  //
  //     print items to the console
  //     - items:      items to print
  //     - separator:  separator between items. Default is space" : "
  //     - terminator: a character inserted at the end of output.
  //
  public static func print(_ items: Any..., separator: String = " : ",
                           terminator: String = "\n", _ file: String = #file,
                           _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
    let filename = file.lastPathComponent.stringByDeletingPathExtension
    var prefix = filename
    prefix += " : \(function): "
    prefix += "[\(line)]: "
    let stringItem = items.map { "\($0)" } .joined(separator: separator)
    Swift.print("\(prefix)\(stringItem)", terminator: terminator)
    #endif
  }
}

// MARK: - String Extension
private extension String {
  var nsstring: NSString {
    return self as NSString
  }
  var lastPathComponent: String {
    return nsstring.lastPathComponent
  }
  var stringByDeletingPathExtension: String {
    return nsstring.deletingPathExtension
  }
}
