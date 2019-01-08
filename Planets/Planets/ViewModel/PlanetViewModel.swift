//
//  PlanetViewModel.swift
//  Planets
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//

import UIKit

class PlanetViewModel: NSObject {

    override init() {
        super.init()
    }
    
    func checkForPlanetLists(onSuccess: @escaping ([PlanetModel]) -> Void, onFailure :@escaping (String) -> Void) {
        let web = WebEngine()
        web.loadPlanetsList(onSuccess: { (planets) in
            onSuccess(planets)
        }) { (error) in
            print(error)
            onFailure(error)
        }
    }
}
