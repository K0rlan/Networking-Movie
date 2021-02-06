//
//  FavouritesTableViewController.swift
//  Networking Movie
//
//  Created by Korlan Omarova on 06.02.2021.
//

import UIKit

class FavouritesTableViewController: UITableViewController {

    var favMovies: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []
        tableView.reloadData()
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavouriteTableViewCell
        cell.titleLabel.text = favMovies[indexPath.row]
        return cell
    }
    



}
