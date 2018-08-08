//
//  ViewController.swift
//  malibu-etag
//
//  Created by Guilherme on 07/08/18.
//  Copyright © 2018 Guilherme. All rights reserved.
//

import UIKit
import Malibu
import When

enum Api: RequestConvertible {
  case course

  static var baseUrl: URLStringConvertible? = "http://127.0.0.1:3000"
  static var headers: [String: String] = [
    "Accept": "application/json",
    "Provider": "iOS",
    "X-App-Name": "iOS Client"
  ]

  var request: Request {
    switch self {
    case .course:
      return Request.get("/endpoint", cachePolicy: .reloadIgnoringLocalCacheData)
    }
  }
}

class ViewController: UIViewController {
  let networking = Networking<Api>()

  @IBAction func sendRequest(_ sender: UIButton) {
    // The cache is cleared only at app start.
    // The first request won't contain the ETag and will be successful.
    // The next requests will contain the ETag, but will fail with "noDataInResponse"

    networking
      .request(.course)
      .toJsonDictionary()
      .done {
        print("done")
        print($0)
      }
      .fail {
        print("fail")
        print($0)
      }
  }
}

