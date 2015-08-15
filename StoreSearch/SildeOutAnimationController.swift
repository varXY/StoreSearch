//
//  SildeOutAnimationController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/15.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.3
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

		if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
			let duration = transitionDuration(transitionContext)
			let containerView = transitionContext.containerView()

			UIView.animateWithDuration(duration, animations: { () -> Void in
				fromView.center.y -= containerView.bounds.size.height
				fromView.transform = CGAffineTransformMakeScale(0.5, 0.5)
			}, completion: { (finished) -> Void in
				transitionContext.completeTransition(finished)
			})
		}
	}
}
