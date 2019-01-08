//
//  PlanetModel.swift
//  Planets
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//

import Foundation

struct PlanetResponse: Codable {
    var results: [PlanetModel]
}
struct PlanetModel: Codable {
    var name: String
}
