//
//  TeaData.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/20.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import Foundation

struct TeaChoicesData {
    
    var name: String
    var drinks: String
    var price: String
    var size: String
    var sugar: SugarLevel
    var ice: IceLevel
    var message: String
    var tapioca:String
    
    init() {
            name = ""
            drinks = ""
            price = ""
            size = ""
            sugar = .regular
            ice = .regular
            message = ""
            tapioca = ""

    }
}

struct DrinksList {
    var name: String
    var price: Int

}

enum SugarLevel:String{
    case regular = "正常", lessSuger = "少糖", halfSuger = "半糖", quarterSuger = "微糖", sugerFree = "無糖"
    
}

enum IceLevel:String{
    case regular = "正常", moreIce = "少冰", easyIce = "微冰", iceFree = "去冰", completelyiceFree = "完全去冰", hot = "熱飲"
}

struct DrinksInformation : Codable{
    var name: String
    var drinks: String
    var size: String
    var sugar: String
    var ice: String
    var tapioca: String
    var price: String
    var message: String
        
        
    init?(json: [String : Any]) {
        guard let name = json["name"] as? String,
            let drinks = json["drinks"] as? String,
            let size = json["size"] as? String,
            let sugar = json["sugar"] as? String,
            let ice = json["ice"] as? String,
            let tapioca = json["tapioca"] as? String,
            let price = json["price"] as? String,
            let message = json["message"] as? String
                
            else {
                return nil
            }
            self.name = name
            self.drinks = drinks
            self.size = size
            self.sugar = sugar
            self.ice = ice
            self.tapioca = tapioca
            self.price = price
            self.message = message
         
    }
    
}

    

