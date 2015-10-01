//
//  GrandientView.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/15.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class GradientView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor.clearColor()

		// This tells the view that it should change both its width and its height proportionally when the superview it belongs to resizes (due to being rotated or otherwise). In practice this means the GradientView will always cover the same area that its superview covers and there should be no more gaps, even if the device gets rotated.
		
		autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
	}

	// init(coder), is never used in this app. However, UIView demands that all subclasses implement init(coder)

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.clearColor()
		autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
	}

	override func drawRect(rect: CGRect) {

		// Create two arrays that contain the “color stops” for the gradient. The first color (0, 0, 0, 0.3) is a black color that is mostly transparent. It sits at location 0 in the gradient, which represents the center of the screen. The second color (0, 0, 0, 0.7) is also black but much less transparent and sits at location 1, which represents the circumference of the gradient’s circle.

		let components: [CGFloat] = [0, 0, 0, 0.3, 0, 0, 0, 0.7]
		let locations: [CGFloat] = [0, 1]

		// Create CGGradient object.

		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)

		let x = CGRectGetMidX(bounds)
		let y = CGRectGetMidY(bounds)
		let point = CGPoint(x: x, y: y)
		let radius = max(x, y)

		// You need to obtain a reference to the current context and then you can do your drawing.

		let context = UIGraphicsGetCurrentContext()
		CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, CGGradientDrawingOptions.DrawsAfterEndLocation)
	}
}
