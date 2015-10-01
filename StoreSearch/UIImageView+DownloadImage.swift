//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/13.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

extension UIImageView {

	func loadImageWithURl(url: NSURL) -> NSURLSessionDownloadTask {
		let session = NSURLSession.sharedSession()

		let downloadTask = session.downloadTaskWithURL(url, completionHandler: { [weak self] url, response, error in
			if error == nil && url != nil {
				if let data = NSData(contentsOfURL: url!) {
					if let image = UIImage(data: data) {

						dispatch_async(dispatch_get_main_queue()) {
							if let strongSelf = self {
								strongSelf.image = image
							}
						}
					}
				}
			}
		})

		// After creating the download task you call resume() to start it, and then return the 
		// NSURLSessionDownloadTask object to the caller. Why return it? That gives the app the opportunity  
		// to call cancel() on the download task.
		
		downloadTask.resume()
		return downloadTask
	}
}