//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/16.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!

	var search: Search!

	private var downloadTasks = [NSURLSessionDownloadTask]()

	// You don’t want the other objects in your app to know about the existence of firstTime, or worse, actually try to use this variable. So use private.
	
	private var firstTime = true

	override func viewDidLoad() {
		super.viewDidLoad()

		// Here you’re going to do your own layout.
		// setTranslatesAutoresizingMaskIntoConstraints(true). That allows you to position and size your views manually by changing their frame property.

		view.removeConstraints(view.constraints())
		view.setTranslatesAutoresizingMaskIntoConstraints(true)

		pageControl.removeConstraints(pageControl.constraints())
		pageControl.setTranslatesAutoresizingMaskIntoConstraints(true)

		scrollView.removeConstraints(scrollView.constraints())
		scrollView.setTranslatesAutoresizingMaskIntoConstraints(true)

		// UIColor has a cool trick that lets you use a tile- able image for a color. By setting this image as a pattern image on the background you get a repeatable image that fills the whole screen.
		
		scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)

		// You don’t change the frame (or bounds) of the scroll view if you want its insides to be bigger, you set the contentSize property instead.
		// scrollView.contentSize = CGSize(width: 1000, height: 1000)

		pageControl.numberOfPages = 0
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		// The scroll view’s frame is the rectangle seen from the perspective of the main view, while the scroll view’s bounds is the same rectangle from the perspective of the scroll view itself.

		scrollView.frame = view.bounds

		pageControl.frame = CGRect(x: 0, y: view.frame.size.height - pageControl.frame.size.height, width: view.frame.size.width, height: pageControl.frame.size.height)

		// The only safe place to perform calculations based on the final size of the view – any calculations that use the view’s frame or bounds – is in viewWillLayoutSubviews().

		if firstTime {
			firstTime = false
			tileButtons(search.searchResults)
		}
	}

	private func tileButtons(searchResults: [SearchResult]) {
		var columnsPerPage = 5
		var rowsPerPage = 3
		var itemWidth: CGFloat = 96
		var itemHeight: CGFloat = 88
		var marginX: CGFloat = 0
		var marginY: CGFloat = 20

		let scrollViewWidth = scrollView.bounds.size.width

		switch scrollViewWidth {
		case 568:
			columnsPerPage = 6
			itemWidth = 94
			marginX = 2

		case 667:
			columnsPerPage = 7
			itemWidth = 95
			itemHeight = 98
			marginX = 1
			marginY = 29

		case 736:
			columnsPerPage = 8
			rowsPerPage = 4
			itemWidth = 92

		default:
			break

			// Doesn't mean break the app, just jump out.
		}

		let buttonWidth: CGFloat = 82
		let buttonHeight: CGFloat = 82
		let paddingHorz = (itemWidth - buttonWidth) / 2
		let paddingVert = (itemHeight - buttonHeight) / 2

		var row = 0
		var column = 0
		var x = marginX

		for (index, searchResult) in enumerate(searchResults) {
			let button = UIButton.buttonWithType(.Custom) as! UIButton
			button.setBackgroundImage(UIImage(named: "LandscapeButton"), forState: .Normal)
			button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row)*itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
			downloadImageForSearchResult(searchResult, andPlaceOnButton: button)
			scrollView.addSubview(button)

			++row
			if row == rowsPerPage {
				row = 0
				++column
				x += itemWidth

				if column == columnsPerPage {
					column = 0
					x += marginX * 2
				}
			}
		}

		let buttonsPerPage = columnsPerPage * rowsPerPage
		let numPages = 1 + (searchResults.count - 1) / buttonsPerPage

		scrollView.contentSize = CGSize(width: CGFloat(numPages)*scrollViewWidth, height: scrollView.bounds.size.height)

		println("Number of pages: \(numPages)")

		pageControl.numberOfPages = numPages
		pageControl.currentPage = 0

	}

	private func downloadImageForSearchResult(searchResult: SearchResult, andPlaceOnButton button: UIButton) {
		if let url = NSURL(string: searchResult.artworkURL60) {
			let session = NSURLSession.sharedSession()
			let downloadTask = session.downloadTaskWithURL(url, completionHandler: { [weak button] url, response, error -> Void in
				if error == nil && url != nil {
					if let data = NSData(contentsOfURL: url) {
						if let image = UIImage(data: data) {
							var image = image.resizedImageWithBounds(CGSize(width: 60, height: 60))

							dispatch_async(dispatch_get_main_queue()) {
								if let button = button {
									button.setImage(image, forState: .Normal)
								}
							}

						}
					}
				}
			})
			downloadTask.resume()
			downloadTasks.append(downloadTask)
		}
	}

	deinit {
		println("deinit \(self)")

		for task in downloadTasks {
			task.cancel()
		}
	}
}


extension LandscapeViewController: UIScrollViewDelegate {

	func scrollViewDidScroll(scrollView: UIScrollView) {
		let width = scrollView.bounds.size.width
		let currentPage = Int((scrollView.contentOffset.x + width/2) / width)
		pageControl.currentPage = currentPage
	}

	@IBAction func pageChanged(sender: UIPageControl) {

		UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
			self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
		}, completion: nil)
	}
}
