//
//  LocalFileUtility.swift
//  PicsumPreviewTests
//
//  Created by Martin on 02/07/20.
//  Copyright © 2020 sls. All rights reserved.
//

import Foundation

public class JsonUtility: NSObject {

  // MARK: - Json file to dictionary array converter
  class func jsonToDictionaryArrayFromFile(_ fileName: String, for aClass: Swift.AnyClass) -> [[String: Any]] {
    guard let filePath = Bundle(for: aClass).path(forResource: fileName, ofType: "json") else { return [[String: Any]]() }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.uncachedRead)
      return dataToDictionaryArray(data)
    } catch {
      return [[String: Any]]()
    }
  }

  class func jsonToPicsumImageModels(fromFile fileName: String, for aClass: Swift.AnyClass) -> [PicsumImageModel] {
    let response = JsonUtility.jsonToDictionaryArrayFromFile(fileName, for: aClass)
    guard let json = try? JSONSerialization.data(withJSONObject: response, options: []),
    let picsumImageModels =  try? JSONDecoder().decode([PicsumImageModel].self, from: json) else {
      return []
    }
    return picsumImageModels
  }

  private class func dataToDictionaryArray(_ data: Data) -> [[String: Any]] {
    guard let jsonResponse = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]]  else {
      return [[String: Any]]()
    }
    return jsonResponse
  }
}
