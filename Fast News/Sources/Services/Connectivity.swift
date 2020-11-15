//
//  Connectivity.swift
//  Fast News
//
//  Created by Pablo Henrique Borsone on 15/11/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
    
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
