//
//  SearchController.swift
//  Easy Digital Downloads
//
//  Created by Sunny Ratilal on 23/09/2016.
//  Copyright © 2016 Easy Digital Downloads. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    private var customSearchBar = SearchBar()

    override var searchBar: UISearchBar {
        get {
            return customSearchBar
        }
    }

}
