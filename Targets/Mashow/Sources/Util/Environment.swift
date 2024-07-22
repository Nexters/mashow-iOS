//
//  Environment.swift
//  Mashow
//
//  Created by Kai Lee on 7/21/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation
import Moya

struct Environment {
    private static let internalNetwork = NetworkManager(provider: MoyaProvider<API>())
    static var network: NetworkManager<API> {
        internalNetwork
    }
}
