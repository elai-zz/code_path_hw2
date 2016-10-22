//
//  Filters.swift
//  A Yelp filter model
//  Yelp
//
//  Created by Estella Lai on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filters: NSObject {
    
    var hasDeal : Bool?
    var distance : Double?
    var selectedCategories = [String]()
    var sortBy : Int?
    
    var categories: [[String:String]]!

    let distanceRowToDistance = [0 : 482, 1: 1609, 2: 3218.69, 3 : 16093.4]
    
    init(switchStates: [[Int:Bool]], categories: [[String:String]]) {
        self.categories = categories
        
        // check for selected categories
        for (row, isSelected) in switchStates[3] {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        // check if deal is on
        if let filterHasDeal = switchStates[0][0] {
            self.hasDeal = filterHasDeal
        } else {
            self.hasDeal = nil
        }
        
        // check if distance is set
        if switchStates[1].count == 0 {
            self.distance = nil
        } else {
            for (row, isSelected) in switchStates[1] {
                if (isSelected) {
                    self.distance = distanceRowToDistance[row]
                    break
                }
            }
        }
        
        // check for sort
        for (row, isSelected) in switchStates[2] {
            if (isSelected) {
                self.sortBy = row
                break
            }
        }

    }
    
    
    
}
