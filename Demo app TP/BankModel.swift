//
//  BankModel.swift
//  Demo app TP
//
//  Created by Jonathan Pabel Saldivar Mendoza on 20/02/20.
//  Copyright © 2020 Jonathan Pabel Saldivar Mendoza. All rights reserved.
//

import Foundation

struct BankModel:Codable {
    var bankName:String
    var description:String
    var age:Int
    var url:String
    
    init(name:String, description:String, age:Int, url:String) {
        self.bankName = name
        self.description = description
        self.age = age
        self.url = url
    }
}
