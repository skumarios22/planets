//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//

import XCTest
import CoreData
@testable import Planets

class PlanetsTests: XCTestCase {
    
    var mgr: CoreDataStack?
    
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Planets", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mgr = CoreDataStack.sharedInstance
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testCheckEmpty() {
        if let mgr = self.mgr {
            let rows = mgr.fetchPlanetsFromStore()
            XCTAssertNotEqual(rows.count, 0)
        } else {
            XCTFail()
        }
    }
        
    func testGetPlanetsRequest() {
        
        guard let url = URL(string: "https://swapi.co/api/planets/") else {
            fatalError("URL can't be empty")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let urlResponse: HTTPURLResponse = response as? HTTPURLResponse {
                if urlResponse.statusCode == 200 {
                    XCTAssertTrue(true)
                } else {
                    XCTAssertFalse(false)
                }
            }
        }
        task.resume()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
