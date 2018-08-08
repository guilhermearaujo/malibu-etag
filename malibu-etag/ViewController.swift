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
      return Request.get("/endpoint")
    }
  }
}

class ViewController: UIViewController {
  var networking: Networking<Api>!

  override func viewDidLoad() {
    super.viewDidLoad()

    let configuration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    networking = Networking<Api>(sessionConfiguration: .custom(configuration))
  }

  @IBAction func sendRequest(_ sender: UIButton) {
    // This should clear the cache before making a new request
    Malibu.clearStorages()

    // The server still always receives the request with the 'If-None-Match' header

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

