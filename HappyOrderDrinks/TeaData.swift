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
            drinks = "冰茉香綠茶"
            price = "40"
            size = "中杯"
            sugar = .regular
            ice = .regular
            message = ""
            tapioca = "不加白玉珍珠"

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
