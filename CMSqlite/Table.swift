//
//  Table.swift
//  CMSqlite
//
//  Created by Craig Miller on 04/06/2014.
//
//

import Foundation

class Table
{
	let _name : String
	
	init(name : String)
	{
		_name = name
		
		type = ""
		
		//columns = []
	}
	
	var type : String
	
	//var columns : TableColumn[]
}
