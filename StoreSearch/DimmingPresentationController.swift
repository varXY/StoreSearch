//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/13.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {

	lazy var dimmingView = GradientView(frame: CGRect.zero)

	// The presentationTransitionWillBegin() method is invoked when the new view controller is about to be shown on the screen. Here you create the GradientView object, make it as big as the containerView, and insert it behind everything else in this “container view”.
	
	override func presentationTransitionWillBegin() {
		dimmingView.frame = containerView!.bounds
		containerView!.insertSubview(dimmingView, atIndex: 0)

		dimmingView.alpha = 0

		// The important thing to know about the transitionCoordinator is that any of your animations should be done in a closure passed to animateAlongsideTransition() to keep the transition smooth.

		if let transitionCoordinator = presentedViewController.transitionCoordinator() {

			transitionCoordinator.animateAlongsideTransition({ (_) -> Void in
				self.dimmingView.alpha = 1
			}, completion: nil)
		}
	}

	override func dismissalTransitionWillBegin() {
		if let transitionCoordinator = presentedViewController.transitionCoordinator() {
			transitionCoordinator.animateAlongsideTransition({ (_) -> Void in
				self.dimmingView.alpha = 0
			}, completion: nil)
		}
	}
	
	override func shouldRemovePresentersView() -> Bool {
		return false
	}
}
