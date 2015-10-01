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
	@IBOutlet weak var segmentedControl: UISegmentedControl!

	weak var splitViewDetail: DetailViewController?

	let search = Search()
	var tempCurrentPage: Int = 0

	var landscapeViewController: LandscapeViewController?

	struct TableViewCellIdentofiers {
    	static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
		static let loadingCell = "LoadingCell"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Search", comment: "Split-view maseter buttion")

		if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
			searchBar.becomeFirstResponder()
		}

		var cellNib = UINib(nibName: TableViewCellIdentofiers.searchResultCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.searchResultCell)

		cellNib = UINib(nibName: TableViewCellIdentofiers.nothingFoundCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.nothingFoundCell)

		cellNib = UINib(nibName: TableViewCellIdentofiers.loadingCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.loadingCell)

		tableView.rowHeight = 80
		tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)

	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		listenForNotification()
	}

	override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

		let rect = UIScreen.mainScreen().bounds
		if (rect.width == 736 && rect.height == 414) || (rect.width == 414 && rect.height == 736) {

			if presentedViewController != nil {
				dismissViewControllerAnimated(true, completion: nil)
			}

		}else if UIDevice.currentDevice().userInterfaceIdiom != .Pad {

			switch newCollection.verticalSizeClass {
			case .Compact:
				showLandscapeViewWithCoordinator(coordinator)
			case .Regular, .Unspecified:
				hideLandscapeViewWithCoordinator(coordinator)
				
			}

		}
	}

	func showLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
		precondition(landscapeViewController == nil)

		landscapeViewController = storyboard!.instantiateViewControllerWithIdentifier("LandscapeViewController") as? LandscapeViewController

		if let controller = landscapeViewController {
			controller.view.frame = view.bounds
			controller.view.alpha = 0
			controller.search = search

			controller.pageFromSearchVC = true
			controller.currentPage = tempCurrentPage

			view.addSubview(controller.view)
			addChildViewController(controller)

			coordinator.animateAlongsideTransition({ (_) -> Void in
				controller.view.alpha = 1
				self.searchBar.resignFirstResponder()

				if self.presentedViewController != nil {
					self.dismissViewControllerAnimated(true, completion: nil)
				}
				
			}, completion: { (_) -> Void in
				controller.didMoveToParentViewController(self)
			})
		}
	}

	func hideLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
		if let controller = landscapeViewController {
			controller.willMoveToParentViewController(nil)

			coordinator.animateAlongsideTransition({ (_) -> Void in
				controller.view.alpha = 0

				if self.presentedViewController != nil {
					self.dismissViewControllerAnimated(true, completion: nil)
				}
				
			}, completion: { (_) -> Void in
				controller.view.removeFromSuperview()
				controller.removeFromParentViewController()
				self.tempCurrentPage = controller.currentPage
				self.landscapeViewController = nil
			})

		}
	}

	@IBAction func segmentChanged(sender: UISegmentedControl) {
		performSearch()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDetail" {
			switch search.state {
			case .Results(let list):
				let detailViewController = segue.destinationViewController as! DetailViewController
				let indexPath = sender as! NSIndexPath
				let searchResult = list[indexPath.row]
				detailViewController.searchResult = searchResult
				detailViewController.isPopUp = true 
			default:
				break
			}

		}
	}

	func listenForNotification() {
		NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (_) -> Void in
			self.tableView.reloadData()
			self.reloadInputViews()
			self.tableView.reloadInputViews()
		}
	}

	func hideMasterPane() {
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			self.splitViewController?.preferredDisplayMode = .PrimaryHidden
			}, completion: { _ in
				self.splitViewController?.preferredDisplayMode = .Automatic
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	

	func showNetworkError() {
		let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "hey"), message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)

		presentViewController(alert, animated: true, completion: nil)
	}

}


extension SearchViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		performSearch()
	}

	func performSearch() {

		tempCurrentPage = 0

		if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {

			search.performSearchForText(searchBar.text!, category: category, completion: { success in

				if !success {
					self.showNetworkError()
				}

				if let controller = self.landscapeViewController {
					controller.searchResultsReceived()
				}

				self.tableView.reloadData()
			})

		tableView.reloadData()
		searchBar.resignFirstResponder()
			
		}
	}

	func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return .TopAttached
	}
}


extension SearchViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		switch search.state {
		case .NotSearchedYet:
			return 0
		case .Loading:
			return 1
		case .NoResults:
			return 1
		case .Results(let list):
			return list.count
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		switch search.state {

		case .NotSearchedYet:
			fatalError("Should never get here")

		case .Loading:
			let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.loadingCell, forIndexPath: indexPath) 
			let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
			spinner.startAnimating()

			return cell

		case .NoResults:
			return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.nothingFoundCell, forIndexPath: indexPath) 

		case .Results(let list):
			let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell

			let searchResult = list[indexPath.row]
			cell.configureForSearchResults(searchResult)

			return cell
		}
	}

}


extension SearchViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .Compact {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			performSegueWithIdentifier("ShowDetail", sender: indexPath)
		} else {
			switch search.state {
			case .Results(let list):
				splitViewDetail?.searchResult = list[indexPath.row]
			default:
				break
			}

			if splitViewController?.displayMode != .AllVisible {
				hideMasterPane()
			}
		}

	}

	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		switch search.state {
		case .NotSearchedYet, .Loading, .NoResults:
			return nil
		case .Results(_):
			return indexPath
		}
	}
}
