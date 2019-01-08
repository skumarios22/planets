//
//  ViewController.swift
//  Planets
//
//  Created by Uttarakawatam, Santosh on 07/01/19.
//  Copyright © 2019 Uttarakawatam, Santosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableV: UITableView!
    private var planetsList: [PlanetModel]?
    private let cellReuseIdentifier = "cell"
    private let viewModel = PlanetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Loading..."
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        loadPlanets()
    }
    
    private func loadPlanets() {
        viewModel.checkForPlanetLists(onSuccess: { (planets) in
            self.planetsList = planets
            DispatchQueue.main.async {
                self.tableV.reloadData()
                self.title = "Planets"
            }
            
        }, onFailure: { (errorMsg) in
            print(errorMsg)
            self.title = "Failed To Load Planets"
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planetsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = planetsList?[indexPath.row].name
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}

