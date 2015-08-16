//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/15.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.4
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

		// To find out what to animate, you look at the transitionContext parameter. This gives you a reference to new view controller and lets you know how big it should be.

		if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
			if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {

				toView.frame = transitionContext.finalFrameForViewController(toViewController)

				transitionContext.containerView().addSubview(toView)

				// The property you’re animating is the transform. 

				toView.transform = CGAffineTransformMakeScale(0.7, 0.7)

				// A keyframe animation lets you animate the view in several distinct stages. The animation consists of several keyframes. It will smoothly proceed from one keyframe to the next over a certain amount of time.

				UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CalculationModeCubic, animations: {

					UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.334, animations: { () -> Void in
						toView.transform = CGAffineTransformMakeScale(1.2, 1.2)

						toView.transform = CGAffineTransformMakeRotation(CGFloat(14.5))

					})

					UIView.addKeyframeWithRelativeStartTime(0.334, relativeDuration: 0.333, animations: { () -> Void in
						toView.transform = CGAffineTransformMakeScale(0.9, 0.9)
						toView.transform = CGAffineTransformMakeRotation(CGFloat(-14.5))
					})

					UIView.addKeyframeWithRelativeStartTime(0.666, relativeDuration: 0.333, animations: { () -> Void in
						toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
					})
					}, completion: { (finished) -> Void in
					transitionContext.completeTransition(finished)
				})
			}
		}
	}
}
