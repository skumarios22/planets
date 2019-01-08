//
//  WebEngine.swift
//  Planets
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//

import UIKit

class WebEngine: NSObject {
    
    static let baseURL: String = "https://swapi.co/api/planets/"
    
    
    func loadPlanetsList(onSuccess: @escaping ([PlanetModel]) -> Void,
                         onFailure: @escaping (String) -> Void ) {
        if Reachability.isConnectedToNetwork() { // Here Checking Network reachability
            guard let serviceURL = URL(string: WebEngine.baseURL) else { return }
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            
            let task = session.dataTask(with: serviceURL) { (data, response, error) in
                if let errorObj = error {
                    onFailure(errorObj.localizedDescription)
                    
                } else {
                    guard let responseData = data else {
                        onFailure("No Response")
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let dataUsage = try decoder.decode(PlanetResponse.self, from: responseData)
                        let results: [PlanetModel] = dataUsage.results
                        if results.count > 0 {
                            //Storing data into Coredata
                            CoreDataStack.sharedInstance.savePlanetsInfo(with: results)
                        }
                        onSuccess(results)
                        
                    } catch let error as NSError {
                        onFailure(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            let results = CoreDataStack.sharedInstance.fetchPlanetsFromStore()
            onSuccess(results)
        }
    }
}
extension WebEngine: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
}
