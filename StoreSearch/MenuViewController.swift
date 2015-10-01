//
//  MenuViewControllerTableViewController.swift
//  StoreSearch
//
//  Created by 文川术 on 15/9/2.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
	func menuViewControllerSendSupportEmail(_: MenuViewController)
}

class MenuViewController: UITableViewController {
	weak var delegate: MenuViewControllerDelegate?

	let cellTitle = ["Send Email", "Two", "Three"]

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellID = "ShareCell"
		var cell = tableView.dequeueReusableCellWithIdentifier(cellID)

		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
		}

		cell?.textLabel?.text = cellTitle[indexPath.row]

		return cell!

	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		if indexPath.row == 0 {
			delegate?.menuViewControllerSendSupportEmail(self)
		}
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Share"
	}
	

}
