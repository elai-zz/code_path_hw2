//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Minnie Lai on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController,
                               didUpdateFilters filters: [String: AnyObject])
}
class FiltersViewController: UIViewController, SwitchCellDelegate,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categories = yelpCategories()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.allowsSelection = false
        
    }

    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchCell
        cell.delegate = self
        cell.switchLabel.text = categories[indexPath.row]["name"]
        // setting states for each reuse cell
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)
        switchStates[(indexPath?.row)!] = value
    }

    func yelpCategories() -> [[String:String]] {
        return [
            ["name": "Afghan", "code": "afghani"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "New American", "code": "newamerican"]
        ]
    }
}
