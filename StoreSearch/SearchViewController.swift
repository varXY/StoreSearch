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

	var searchResults = [SearchResult]()
	var hasSearched = false
	var isLoading = false

	struct TableViewCellIdentofiers {
    	static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
		static let loadingCell = "LoadingCell"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		searchBar.becomeFirstResponder()

		var cellNib = UINib(nibName: TableViewCellIdentofiers.searchResultCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.searchResultCell)

		cellNib = UINib(nibName: TableViewCellIdentofiers.nothingFoundCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.nothingFoundCell)

		cellNib = UINib(nibName: TableViewCellIdentofiers.loadingCell, bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentofiers.loadingCell)

		tableView.rowHeight = 80
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Networking

	func urlWithSearchText(searchText: String) -> NSURL {

		// This calls the stringByAddingPercentEscapesUsingEncoding() method to escape the special characters, which returns a new string that you then use for the search term. In theory this method can return nil for certain encodings but because you chose the UTF-8 encoding here that won’t ever happen, so you can safely force-unwrap the return value with the exclamation point at the end. (You could also have used if let.)

		let escapedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
		let urlString = String(format: "http://itunes.apple.com/search?term=%@", escapedSearchText)
		let url = NSURL(string: urlString)
		return url!
	}

	func parseJOSN(data: NSData) -> [String: AnyObject]?  {
		var error: NSError?

		if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject] {
			return json
		} else if let error = error {
			println("JSON Error: \(error)")
		} else {
			println("Unknown JSON Error")
		}
		return nil
	}

	func showNetworkError() {
		let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)

		presentViewController(alert, animated: true, completion: nil)
	}

	// MARK: 

	func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult] {

		var searchResults = [SearchResult]()
		if let array: AnyObject = dictionary["results"] {

			for resultDict in array as! [AnyObject] {
				if let resultDict = resultDict as? [String: AnyObject] {
					var searchResult: SearchResult?

					if let wrapperType = resultDict["wrapperType"] as? NSString {
						switch wrapperType {
						case "track":
							searchResult = parseTrack(resultDict)
						case "audiobook":
							searchResult = parseAudioBook(resultDict)
						case "software":
							searchResult = parseSoftware(resultDict)
						default:
							break
						}
					} else if let kind = resultDict["kind"] as? NSString {
						if kind == "ebook" {
							searchResult = parseEBook(resultDict)
						}
					}

					if let result = searchResult {
						searchResults.append(result)
					}

				} else {
					println("Expected a dictionary")
				}
			}

		} else {
			println("Expected 'results' array")
		}
		return searchResults
	}

	func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
		let searchResult = SearchResult()

		searchResult.name = dictionary["trackName"] as! NSString as String
		searchResult.artistName = dictionary["artistName"] as! NSString as String
		searchResult.artworkURL60 = dictionary["artworkUrl60"] as! NSString as String
		searchResult.artworkURL100 = dictionary["artworkUrl100"] as! NSString as String
		searchResult.storeURL = dictionary["trackViewUrl"] as! NSString as String
		searchResult.kind = dictionary["kind"] as! NSString as String
		searchResult.currency = dictionary["currency"] as! NSString as String

		if let price = dictionary["trackPrice"] as? NSNumber {
			searchResult.price = Double(price)
		}

		if let genre = dictionary["primaryGenreName"] as? NSString {
			searchResult.genre = genre as String
		}

		return searchResult
	}

	func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
		let searchResult = SearchResult()
		searchResult.name = dictionary["collectionName"] as! NSString as String
		searchResult.artistName = dictionary["artistName"] as! NSString as String
		searchResult.artworkURL60 = dictionary["artworkUrl60"] as! NSString as String
		searchResult.artworkURL100 = dictionary["artworkUrl100"] as! NSString as String
		searchResult.storeURL = dictionary["collectionViewUrl"] as! NSString as String
		searchResult.kind = "audiobook"
		searchResult.currency = dictionary["currency"] as! NSString as String

		if let price = dictionary["collectionPrice"] as? NSNumber {
			searchResult.price = Double(price)
		}
		if let genre = dictionary["primaryGenreName"] as? NSString {
			searchResult.genre = genre as String
		}
		return searchResult
	}

	func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
		let searchResult = SearchResult()
		searchResult.name = dictionary["trackName"] as! NSString as String
		searchResult.artistName = dictionary["artistName"] as! NSString as String
		searchResult.artworkURL60 = dictionary["artworkUrl60"] as! NSString as String
		searchResult.artworkURL100 = dictionary["artworkUrl100"] as! NSString as String
		searchResult.storeURL = dictionary["trackViewUrl"] as! NSString as String
		searchResult.kind = dictionary["kind"] as! NSString as String
		searchResult.currency = dictionary["currency"] as! NSString as String

		if let price = dictionary["price"] as? NSNumber {
			searchResult.price = Double(price)
		}
		if let genre = dictionary["primaryGenreName"] as? NSString {
			searchResult.genre = genre as String
		}
		return searchResult
	}

	func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
		let searchResult = SearchResult()
		searchResult.name = dictionary["trackName"] as! NSString as String
		searchResult.artistName = dictionary["artistName"] as! NSString as String
		searchResult.artworkURL60 = dictionary["artworkUrl60"] as! NSString as String
		searchResult.artworkURL100 = dictionary["artworkUrl100"] as! NSString as String
		searchResult.storeURL = dictionary["trackViewUrl"] as! NSString as String
		searchResult.kind = dictionary["kind"] as! NSString as String
		searchResult.currency = dictionary["currency"] as! NSString as String

		if let price = dictionary["price"] as? NSNumber {
			searchResult.price = Double(price)
		}
		if let genres: AnyObject = dictionary["genres"] {
			searchResult.genre = ", ".join(genres as! [String])
		}
		return searchResult
	}

	func kindForDisplay(kind: String) -> String {
		switch kind {
			case "album": return "Album"
			case "audiobook": return "Audio Book"
			case "book": return "Book"
			case "ebook": return "E-Book"
			case "feature-movie": return "Movie"
			case "music-video": return "Music Video"
			case "podcast": return "Podcast"
			case "software": return "App"
			case "song": return "Song"
			case "tv-episode": return "TV Episode"
			default: return kind
		}
	}


}


extension SearchViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		if !searchBar.text.isEmpty {
			searchBar.resignFirstResponder()

			isLoading = true
			tableView.reloadData()

			hasSearched = true
			searchResults = [SearchResult]()

			let url = self.urlWithSearchText(searchBar.text)
			let session = NSURLSession.sharedSession()
			let dataTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
				if let error = error {
					println("Failure! \(error)")
				} else if let httpResponse = response as? NSHTTPURLResponse {

					// How to tell whether a particular piece of code is being run on the main thread

					println("On the main thread? " + (NSThread.currentThread().isMainThread ? "Yes" : "No"))

					// Because you’re using the HTTP protocol what you’ve really received is an NSHTTPURLResponse object, a subclass of NSURLResponse.

					if httpResponse.statusCode == 200 {
						if let dictionary = self.parseJOSN(data) {
							self.searchResults = self.parseDictionary(dictionary)
							self.searchResults.sort(<)

							dispatch_async(dispatch_get_main_queue()) {
								self.isLoading = false
								self.tableView.reloadData()
							}

							// Without return, self.showNetworkError()

							return
						}
					} else {
						println("Failure! \(response)")
					}
				}

				dispatch_async(dispatch_get_main_queue()) {
					self.hasSearched = false
					self.isLoading = false
					self.tableView.reloadData()
					self.showNetworkError()
				}
			})

			dataTask.resume()
		}
	}

	func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return .TopAttached
	}
}


extension SearchViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if isLoading {
			return 1
		} else if !hasSearched {
			return 0
		} else if searchResults.count == 0 {
			return 1
		} else {
			return searchResults.count
		}
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		if isLoading {
			let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.loadingCell, forIndexPath: indexPath) as! UITableViewCell
			let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
			spinner.startAnimating()

			return cell
		}

		if searchResults.count == 0 {
			return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.nothingFoundCell, forIndexPath: indexPath) as! UITableViewCell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentofiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
			let searchResult = searchResults[indexPath.row]

			cell.nameLabel?.text = searchResult.name

			if searchResult.artistName.isEmpty {
				cell.artistNameLabel.text = "Unknown"
			} else {
				cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kindForDisplay(searchResult.kind))
			}

			return cell
		}
	}
}


extension SearchViewController: UITableViewDelegate {

	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if searchResults.count == 0 || isLoading {
			return nil
		} else {
			return indexPath
		}
	}
}
