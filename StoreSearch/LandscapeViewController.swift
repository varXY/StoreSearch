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

	var searchResults = [SearchResult]()

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
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		// The scroll view’s frame is the rectangle seen from the perspective of the main view, while the scroll view’s bounds is the same rectangle from the perspective of the scroll view itself.

		scrollView.frame = view.bounds

		pageControl.frame = CGRect(x: 0, y: view.frame.size.height - pageControl.frame.size.height, width: view.frame.size.width, height: pageControl.frame.size.height)

		// The only safe place to perform calculations based on the final size of the view – any calculations that use the view’s frame or bounds – is in viewWillLayoutSubviews().

		if firstTime {
			firstTime = false
			tileButtons(searchResults)
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
		case 586:
			columnsPerPage = 6
			itemWidth = 94
			marginX = 2

		case 667:
			columnsPerPage = 7
			itemWidth = 94
			marginX = 1
			marginY = 29

		default:
			break
		}

		// TODO: more to come here
	}

	deinit {
		println("deinit \(self)")
	}
}
