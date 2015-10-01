//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/13.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

	@IBOutlet weak var popupView: UIView!
	@IBOutlet weak var artworkImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var kindLabel: UILabel!
	@IBOutlet weak var genreLabel: UILabel!
	@IBOutlet weak var priceButton: UIButton!

	var isPopUp = false
	var searchResult: SearchResult! {
		didSet {
			if isViewLoaded() {
				updateUI()
			}
		}
	}
	var downloadTask: NSURLSessionDownloadTask?

	enum AnimationStyle {
		case Slide
		case Fade
	}

	var dismissAnimationStyle = AnimationStyle.Fade

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .Custom
		transitioningDelegate = self
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)

		popupView.layer.cornerRadius = 10

		if isPopUp {
			let gestureRecognizer = UITapGestureRecognizer(target: self, action: ("close"))
			gestureRecognizer.cancelsTouchesInView = false
			gestureRecognizer.delegate = self
			view.addGestureRecognizer(gestureRecognizer)

			view.backgroundColor = UIColor.clearColor()
		} else {
			view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
			popupView.hidden = true

			if let displayName = NSBundle.mainBundle().localizedInfoDictionary?["CFBundleDisplayName"] as? NSString {
				title = displayName as String
			}
		}


		if searchResult != nil {
			updateUI()
		}
	}

	@IBAction func close() {
		dismissAnimationStyle = .Slide
		dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func openInStore() {
		if let url = NSURL(string: searchResult.storeURL) {
			UIApplication.sharedApplication().openURL(url)
		}
	}

	func updateUI() {
		popupView.hidden = false
		
		nameLabel.text = searchResult.name

		if searchResult.artistName.isEmpty {
			artistNameLabel.text = "Unknown"
		} else {
			artistNameLabel.text = searchResult.artistName
		}

		kindLabel.text = searchResult.kindForDisplay()
		genreLabel.text = searchResult.genre

		let formatter = NSNumberFormatter()
		formatter.numberStyle = .CurrencyStyle
		formatter.currencyCode = searchResult.currency

		var priceText: String
		if searchResult.price == 0 {
			priceText = NSLocalizedString("Free", comment: "for the price")
		} else if let text = formatter.stringFromNumber(searchResult.price) {
			priceText = text
		} else {
			priceText = ""
		}
		priceButton.setTitle(priceText, forState: .Normal)

		if let url = NSURL(string: searchResult.artworkURL100) {
			downloadTask = artworkImageView.loadImageWithURl(url)
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowMenu" {
			let navigationController = segue.destinationViewController as! UINavigationController
			let controller = navigationController.topViewController as! MenuViewController
			controller.delegate = self
		}
	}

	deinit {
		downloadTask?.cancel()
	}
}

extension DetailViewController: UIViewControllerTransitioningDelegate {

	func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
		return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
	}

	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return BounceAnimationController()
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		switch dismissAnimationStyle {
		case .Slide:
			return SlideOutAnimationController()
		case .Fade:
			return FadeOutAnimationController()
		}
	}
}

extension DetailViewController: UIGestureRecognizerDelegate {

	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		return (touch.view === self.view)
	}
}

extension DetailViewController: MenuViewControllerDelegate {
	func menuViewControllerSendSupportEmail(_: MenuViewController) {

		dismissViewControllerAnimated(true, completion: { () -> Void in
			if MFMailComposeViewController.canSendMail() {
				let controller = MFMailComposeViewController()
				controller.mailComposeDelegate = self
				controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
				controller.setToRecipients(["1046509735@qq.com"])
				controller.modalPresentationStyle = .FormSheet
				self.presentViewController(controller, animated: true , completion: nil)
			}
		})
	}
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
