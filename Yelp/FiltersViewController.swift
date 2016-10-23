//
//  FiltersViewController.swift
//  A Yelp filters view controller
//  Yelp
//
//  Created by Minnie Lai on 10/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController,
                               didUpdateFilters filters: Filters)
}
class FiltersViewController: UIViewController, SwitchCellDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [[Int:Bool]]()
    
    // Hardcoded information for setting up the table
    let titleArray = ["Deal", "Distance", "Sort By", "Category"]
    let numberOfCellsInSection = [1, 4, 3, 6]
    let staticNameArrayDictionary = [
        ["Offering a Deal"],
        ["0.3 mi", "1 mi", "5 mi", "10 mi"],
        ["Best Matched", "Distance", "Highest Rated"]
    ]
    let CellIdentifier = "FiltersTableViewCell", HeaderViewIdentifier = "FiltersTableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SEtting up the switchStates array of dictionaries
        for _ in 0...4 {
            let newDict = [Int:Bool]()
            switchStates.append(newDict)
        }

        // Do any additional setup after loading the view.
        categories = self.yelpCategories()
        setUpTableView()
    }

    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        let filters = Filters(switchStates: switchStates, categories: categories)
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTableView() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.allowsSelection = false
        filtersTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        filtersTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return numberOfCellsInSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filtersTableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchCell
        cell.delegate = self
        
        let section = indexPath.section
        let row = indexPath.row

        // Sections with numbers greater than 2 has multiple cells in the section 
        // and receives special set up instruction
        if (section > 2) {
            cell.switchLabel.text = categories[indexPath.row]["name"]
        } else {
            cell.switchLabel.text = staticNameArrayDictionary[section][row]
        }
        
        // Setting state for each reuse cell
        cell.onSwitch.isOn = switchStates[section][row] ?? false
        return cell
    }
    
    // Hardcoded to 4 sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = filtersTableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)! as UITableViewHeaderFooterView
        header.textLabel?.text = titleArray[section]
        return header
    }
    
    // Hardcoded to 30
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Function that Switch Cells call when its switch is toggled
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)
        doForceOtherSwitchesOff(section: (indexPath?.section)!)
        switchStates[(indexPath?.section)!][(indexPath?.row)!] = value
    }
    
    // Function that forces only one "on" state for sections 2 and 3
    func doForceOtherSwitchesOff(section: Int) {
        if (section == 1 || section == 2) {
            for (row, _) in switchStates[section] {
                switchStates[section][row] = false
            }
        }
        filtersTableView.reloadData()
    }

    // Hardcoded Yelp categories as specified in its API
    func yelpCategories() -> [[String:String]] {
        return [
            ["name": "Afghan", "code": "afghani"],
            ["name": "African", "code": "african"],
            ["name": "Chinese", "code": "chinese"],
            ["name": "French", "code": "french"],
            ["name": "New American", "code": "newamerican"],
            ["name": "Traditional American", "code": "tramerican"]
        ]
    }
}
