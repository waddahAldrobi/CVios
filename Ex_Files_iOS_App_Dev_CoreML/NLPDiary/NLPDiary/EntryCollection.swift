//
//  ViewController.swift
//  NLPDiary
//
//  Created by Brian Advent on 29.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation


class EntryCollection {

    var entries: [String]?
    
    init() {
        let entriesURL = Bundle.main.url(forResource: "Entries", withExtension: "plist")!
        self.entries = NSArray(contentsOf: entriesURL) as? [String]
    }

}
