//
//  TableColumn.swift
//  CMSqlite
//
//  Created by Craig Miller on 04/06/2014.
//
//

import Foundation

class TableColumn
{
	var name : String
	var type : String
	var length : Int
	
	init(name : String, type : String, length : Int)
	{
		self.name = name
		self.type = type
		self.length = length
	}
}
