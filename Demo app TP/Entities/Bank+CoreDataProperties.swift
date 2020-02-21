//
//  Bank+CoreDataProperties.swift
//  Demo app TP
//
//  Created by Jonathan Pabel Saldivar Mendoza on 20/02/20.
//  Copyright © 2020 Jonathan Pabel Saldivar Mendoza. All rights reserved.
//
//

import Foundation
import CoreData


extension Bank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bank> {
        return NSFetchRequest<Bank>(entityName: "Bank")
    }

    @NSManaged public var bank_name: String?
    @NSManaged public var descript: String?
    @NSManaged public var age: Int16
    @NSManaged public var url: String?

}
