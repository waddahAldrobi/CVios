//
//  ViewController.swift
//  NLPDiary
//
//  Created by Brian Advent on 29.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var entryFilter = EntryFilter(entryCollection: EntryCollection())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        entryFilter.searchString = ""
        entryTextView.text = entryFilter.filteredEntries.first
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let searchString = searchBar.text {
            entryFilter.searchString = searchString
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryFilter.filteredEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let entry = entryFilter.filteredEntries[indexPath.row]
        
        cell.textLabel?.text = entry
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entryFilter.filteredEntries[indexPath.row]
        entryTextView.text = entry
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

