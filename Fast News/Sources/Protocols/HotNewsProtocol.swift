//
//  HotNewsProtocol.swift
//  Fast News
//
//  Created by Pablo Henrique Borsone on 10/11/20.
//  Copyright © 2020 Lucas Moreton. All rights reserved.
//

import Foundation
import Alamofire

protocol HotNewsProtocol {
    var endpoint: String { get }
    var parameters: Parameters { get }
    var type: Decodable { get }
}
