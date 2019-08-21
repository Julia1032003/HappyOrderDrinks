//
//  OrderDrinksTableViewController.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/19.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class OrderDrinksTableViewController: UITableViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var drinksPicker: UIPickerView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet var iceSegmentedControl: UISegmentedControl!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var tapiocaSwitch: UISwitch!
    
    var teaorder = TeaChoicesData ()
    var drinksData : [DrinksList] = []
    var teaIndex = 0
    
    override func viewDidLoad() {
            super.viewDidLoad()
            getTeaMenu()
            updatePriceUI()
            
        }
    
    

    /*func updatePickerView(row: Int) {
        // 讓pickerView顯示選定的index項目
        drinksPicker.selectRow(row, inComponent: 0, animated: true)
        teaIndex = row
        }*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        //回傳類別
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinksData.count
        //回傳飲料名稱數量
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinksData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         teaIndex = row
         updatePriceUI()
        
    }
    
    //容量大小控制
    @IBAction func sizeSelectSegmentedAction(_ sender: Any) {
        if sizeSegmentedControl.selectedSegmentIndex == 0 {
           sizeSegmentedControl.selectedSegmentIndex = 1
                    
     }
    }
    
    //加價購白玉珍珠
    @IBAction func tapiocaSelectSwitch(_ sender: UISwitch) {
        if sender.isOn{
            priceLabel.text = "NT. \(drinksData[teaIndex].price+10)"
        }else{
            priceLabel.text = "NT. \(drinksData[teaIndex].price)"
        }
    }
    
    //提示訊息
    func showAlertMessage(title: String, message: String) {
            let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
            inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
            self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
        
    //訂單內容
    func getOrder() {
        guard let name = nameTextField.text, name.count > 0 else{   // 檢查姓名是否輸入
        return showAlertMessage(title: "忘記輸入你的名字囉!",message: "沒寫名字怎麼知道是誰點的啦XD")    // 顯示必須輸入的提示訊息
    }
            
            //姓名資料
            teaorder.name = name
            print("訂購人：\(name)")
            
            //飲料資料
            teaorder.drinks = drinksData[teaIndex].name
            print("飲料品項：\(teaorder.drinks)")
            
            //容量資料
            if sizeSegmentedControl.selectedSegmentIndex == 0 {
                teaorder.size = "中杯"
            }else {
                teaorder.size = "大杯"
            }
            print("容量：\(teaorder.size)")
            
            //甜度資料
            switch sugarSegmentedControl.selectedSegmentIndex {
            case 0:
                teaorder.sugar = .regular
            case 1:
                teaorder.sugar = .lessSuger
            case 2:
                teaorder.sugar = .halfSuger
            case 3:
                teaorder.sugar = .quarterSuger
            case 4:
                teaorder.sugar = .sugerFree
            default:
                break
            }
            print("甜度：\(teaorder.sugar.rawValue)")
            
            //冰度資料
            switch iceSegmentedControl.selectedSegmentIndex {
            case 0:
                teaorder.ice = .regular
            case 1:
                teaorder.ice = .moreIce
            case 2:
                teaorder.ice = .easyIce
            case 3:
                teaorder.ice = .iceFree
            case 4:
                teaorder.ice = .completelyiceFree
            case 5:
                teaorder.ice = .hot
            default:
                break
            }
            print("冰度：\(teaorder.ice.rawValue)")
            
            if tapiocaSwitch.isOn {
               print("加購白玉珍珠")
            }else {
               print("不加購白玉珍珠")
             
            //價格資料
            if let price = priceLabel.text {
                            let money = (price as NSString).substring(from: 4) //因為顯示時有加上NT. ，所以移除後上傳
                            teaorder.price = money
                        }
                        print("價格：\(teaorder.price)")
            
            //留言欄
            if let message = messageTextField.text {
                teaorder.message = message
                print("備註：\(message)")
            }
          
        }
    
    }
    
    //傳送訂單資料至sheetDB
    func sendDrinksOrderToServer() {
        
            //POST的API需要知道上傳的資料是什麼格式，所以依照API Documentation的規定設定
            let url = URL(string: "https://sheetdb.io/api/v1/co2xognew7ev0")
            var urlRequest = URLRequest(url: url!)
            // 上傳資料所以設定為POST
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //post所提供的API，Value為物件的陣列（Array），所以利用Dictionary實作
            let confirmOrder: [String : String] = ["name": teaorder.name, "drinks": teaorder.drinks, "size": teaorder.size, "sugar": teaorder.sugar.rawValue, "ice": teaorder.ice.rawValue, "tapioca": teaorder.tapioca, "message": teaorder.message, "price": teaorder.price]
            
            //Post API 需要在物件（Object）內設定key值為data, value為一個物件的陣列（Array）
            let postData: [String: Any] = ["data" : confirmOrder]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: postData, options: []) // 將Data轉為JSON格式
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in // 背景上傳資料
                    NotificationCenter.default.post(name: Notification.Name("waitMessage"), object: nil, userInfo: ["message": true])
                }
                task.resume()
            }
            catch{
            }
        }
    
    func updatePriceUI() {
         priceLabel.text = "NT. \(drinksData[teaIndex].price)"
    }
    

    @IBAction func confirmButton(_ sender: Any) {
        getOrder()
        sendDrinksOrderToServer()
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    
    func getTeaMenu() {
        if let url = Bundle.main.url(forResource: "可不可", withExtension: "txt"), let content = try? String(contentsOf: url) {
            // 開啟飲料txt檔，並將資料讀取出來
            let menuArray = content.components(separatedBy: "\n")  //利用components將換行移除
            for number in 0 ..< menuArray.count {
                            if number % 2 == 0 {
                                let name = menuArray[number]
                                if let price = Int(menuArray[number + 1]) {
                                        drinksData.append(DrinksList(name: name, price: price))
                                }else {
                                    print("轉型失敗")
                                }
                                
                            }
                        }
            }
     }
        
        
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}