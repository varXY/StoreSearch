//
//  SearchResult.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/8.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import Foundation


func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
	return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedAscending
}

class SearchResult {
	var name = ""
	var artistName = ""
	var artworkURL60 = ""
	var artworkURL100 = ""
	var storeURL = ""
	var kind = ""
	var currency = ""
	var price = 0.0
	var genre = ""
}
