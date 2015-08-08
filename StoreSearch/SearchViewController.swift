//
//  ViewController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/8.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!

	var searchResults = [SearchReault]()
	var hasSearched = false

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


extension SearchViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		
		searchResults = [SearchReault]()

		if searchBar.text != "justin bieber" {
			for i in 0...2 {
				let searchReault = SearchReault()
				searchReault.name = String(format: "Fake Result %d for", i)
				searchReault.artistName = searchBar.text
				searchResults.append(searchReault)
			}
		}
		hasSearched = true
		tableView.reloadData()
	}

	func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return .TopAttached
	}
}


extension SearchViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if !hasSearched {
			return 0
		} else if searchResults.count == 0 {
			return 1
		} else {
			return searchResults.count
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "SearchResultsCell"

		var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!

		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
		}

		if searchResults.count == 0 {
			cell.textLabel!.text = "(Noting found)"
			cell.detailTextLabel!.text = ""
		} else {
			let searchResult = searchResults[indexPath.row]
			cell.textLabel!.text = searchResult.name
			cell.detailTextLabel!.text = searchResult.artistName
		}

		return cell
	}
}


extension SearchViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if searchResults.count == 0 {
			return nil
		} else {
			return indexPath
		}
	}
}
