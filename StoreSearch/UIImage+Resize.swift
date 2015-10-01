//
//  UIImage+Resize.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/28.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

extension UIImage {

	func resizedImageWithBounds(bounds: CGSize) -> UIImage {
		let horizontalRatio = bounds.width / size.width
		let verticalRatio = bounds.height / size.height
		let ratio = min(horizontalRatio, verticalRatio)
		let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

		UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
		drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage
	}
}
