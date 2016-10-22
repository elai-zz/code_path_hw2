//
//  BusinessesViewController.swift
//  A Yelp business list view controller
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchString: String?
    var isFiltered = false

    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpSearchBar()
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    self.tableView.reloadData()
                }
            }
            
            }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        var count: Int
        if isFiltered {
            count = filteredBusinesses?.count ?? 0
        } else {
            count = businesses?.count ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath as IndexPath) as! BusinessCell
        if isFiltered {
            cell.business = filteredBusinesses[indexPath.row]

        } else {
            cell.business = businesses[indexPath.row]
        }
        // After we have loaded the view with filtered (or unfiltered) results, we go back to the original state of beig unfiltered.
        self.isFiltered = false
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    // a function that is called by the FiltersViewController when filters are updated
    func filtersViewController(filtersViewController: FiltersViewController,
                               didUpdateFilters filters: Filters)
    {
        let categories = filters.selectedCategories
        let sortMethod = filters.sortBy
        let findDeals = filters.hasDeal
        let radius = filters.distance
        
        Business.searchWithTerm(term: "Restaurants", sort: sortMethod.map { YelpSortMode(rawValue: $0) }!, categories: categories, deals: findDeals, radius: radius)
        { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    func setUpSearchBar() {
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.allowsSelection = false
    }
    
    fileprivate func doSearch(searchString: String) {
        filteredBusinesses = businesses.filter { business in
            return (business.name?.lowercased()
                .contains(searchString.lowercased()))!
        }
        self.isFiltered = true
        self.tableView.reloadData()
    }
}

// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isFiltered = false
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch(searchString: searchBar.text!)
    }
}
