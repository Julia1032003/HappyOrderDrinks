//
//  DrinksTableViewCell.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/22.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var drinksLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var sugerLabel: UILabel!
    @IBOutlet var iceLabel: UILabel!
    @IBOutlet var tapiocaLabel:UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!

    
        
        var cellinformation: DrinksInformation!
      
        func updateUI(id: Int ){
            numberLabel.text = "\(id + 1)."
            nameLabel.text = "訂購者：\(cellinformation.name)"
            drinksLabel.text = "飲料：\(cellinformation.drinks)"
            sizeLabel.text = "容量：\(cellinformation.size)"
            sugerLabel.text = "甜度：\(cellinformation.sugar)"
            iceLabel.text = "冰度：\(cellinformation.ice)"
            tapiocaLabel.text = "珍珠要嗎：\(cellinformation.tapioca)"
            priceLabel.text = "金額：\(cellinformation.price)"
            messageLabel.text = "備註：\(cellinformation.message)"
         
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
