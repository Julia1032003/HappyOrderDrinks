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
    
    @IBOutlet var orderButtonUI: UIButton!
    @IBOutlet var editButtonUI: UIButton! 
    
    
    var teaorder = TeaChoicesData ()
    var drinksData : [DrinksList] = []
    var teaIndex = 0
    var drinksPrice = Int()
    var editOrderData: DrinksInformation?
    
    
    //載入訂購飲料的頁面，判斷呈現什麼畫面
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //若飲料訂單資料不是空值則載入飲料訂單資料
        if editOrderData != nil{
           editOrderList()
           orderButtonUI.alpha = 0
            
        }else{
            
        //若飲料訂單為空值則載入飲料menu
            getTeaMenu() //載入飲料menu
            updatePriceUI() //更新飲料價格
            editButtonUI.alpha = 0
            
        }
    }
    
    // 開啟飲料txt檔，並將資料讀取出來
        func getTeaMenu() {
                    if let url = Bundle.main.url(forResource: "可不可", withExtension: "txt"), let content = try? String(contentsOf: url) {
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
    
    //更新價格等同於選定的項目價格
    func updatePriceUI() {
        priceLabel.text = "NT. \(drinksData[teaIndex].price)"
        drinksPrice = drinksData[teaIndex].price
    }
        
    //載入飲料訂單的資料
    func editOrderList(){
        nameTextField.text = editOrderData?.name
        updateDrinksPickerView(name: editOrderData!.drinks)
        priceLabel.text = editOrderData?.price
        sizeSegmentedControl.selectedSegmentIndex = convertStringToIndex(str: editOrderData!.size)
        sugarSegmentedControl.selectedSegmentIndex = convertStringToIndex(str: editOrderData!.sugar)
        iceSegmentedControl.selectedSegmentIndex = convertStringToIndex(str: editOrderData!.ice)
        tapiocaSwitch.isOn = editOrderData?.tapioca == "要加" ? true : false
        messageTextField.text = editOrderData?.message
    }
    
    //轉換容量、甜度及冰度字串資料
    func convertStringToIndex(str: String) -> Int {
            switch str {
            case "大杯", "正常":
                return 0
            case "中杯", "少糖", "少冰":
                return 1
            case "半糖", "微冰":
                return 2
            case "微糖", "去冰":
                return 3
            case "無糖", "完全去冰":
                return 4
            case "熱飲":
                return 5
            default:
                return 0
            }
        }
    
    // 找出飲料在列表中的index
    func updateDrinksPickerView(name: String) {
            getTeaMenu()
            for (i, drinks) in drinksData.enumerated() {
                if drinks.name == name {
                    updatePickerUI(row: i)
                    break
                }
                 print("ok")
            }
        }
    
     
    //更新PickerView
    func updatePickerUI(row:Int){
            //讓pickerview顯示選定的項目
            drinksPicker.selectRow(row, inComponent: 0, animated: true)
            teaIndex = row
        }

    
   //PickerView的設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        //回傳顯示幾個類別的pikcer
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinksData.count
        //回傳顯示飲料名稱數量
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinksData[row].name
     //顯示文字在Picker上，titleForRow為現在要顯示的文字是在Picker上的第幾個，如果剛剛的numberOfComponents()有設定超過1的話，這邊的第三個參數component就可以用來判斷每個component要顯示的文字。

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         teaIndex = row
         updatePriceUI()
         updateSizeSegmentedControl()
         updatetapiocaSelectSwitch()
        //判斷現在選到的是第幾個，並依據選到的結果顯示對應的價格及初始容量為中杯、珍珠為off
    }
    
    //如果換飲料就更新容量為中杯
    func updateSizeSegmentedControl(){
          sizeSegmentedControl.selectedSegmentIndex = 1
    }
    
    //如果換飲料就更新珍珠的Switch為off(不加珍珠)
    func updatetapiocaSelectSwitch(){
          tapiocaSwitch.isOn = false
    }
    
    
    
    //容量大小的加價選項以及控制熟成檸果只能選中杯
    @IBAction func sizeSelectSegmentedControl(_ sender: UISegmentedControl) {
        
            let name = ["春梅冰茶","冷露歐蕾","熟成歐蕾","白玉歐蕾"]
                if name.contains(drinksData[teaIndex].name) && sizeSegmentedControl.selectedSegmentIndex == 0 {
                    drinksPrice = drinksData[teaIndex].price+10
                    print("加十元")
                    priceLabel.text = "NT. \(drinksPrice)"
                }else if drinksData[teaIndex].name == "熟成檸果"  {
                    priceLabel.text = "NT. \(drinksData[teaIndex].price)"
                }else if sizeSegmentedControl.selectedSegmentIndex == 0 {
                    drinksPrice = drinksData[teaIndex].price+5
                    print("加五元")
                    priceLabel.text = "NT. \(drinksPrice)"
                
                }else{
                priceLabel.text = "NT. \(drinksData[teaIndex].price)"
                }
        
        if drinksData[teaIndex].name == "熟成檸果" {
           showAlertMessage(title: "熟成檸果只有中杯喲",message: "請選擇中杯或是換飲料品項")
           sizeSegmentedControl.selectedSegmentIndex = 1
        }
           
    }

    //加價購白玉珍珠
    @IBAction func tapiocaSelectSwitch(_ sender: UISwitch) {
        if sender.isOn{
            priceLabel.text = "NT. \(drinksPrice+10)"
        }else{
            priceLabel.text = "NT. \(drinksPrice)"
        }
    }

    
    //亂數選飲料
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake{
            let row = Int.random(in: 0 ..< drinksData.count)
            updatePickerUI(row: row)
            updatePriceUI()
        }
    }
    
    
    //提示訊息
    func showAlertMessage(title: String, message: String) {
            let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
            inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
            self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
        
    //取得訂單內容
    func getOrder() {
           guard let name = nameTextField.text, name.count > 0 else{   // 檢查姓名是否輸入
                    return showAlertMessage(title: "忘記輸入你的名字囉!",message: "沒寫名字怎麼知道是誰點的啦XD")    // 顯示必須輸入的提示訊息
           }
           if  drinksData[teaIndex].name == "熟成檸果" {
               showAlertMessage(title: "熟成檸果只有中杯喲",message: "請選擇中杯或是換飲料品項")
               return sizeSegmentedControl.selectedSegmentIndex = 1
                      
           }
        
                        
            //姓名資料
            teaorder.name = name
            print("訂購人：\(name)")
            
            //飲料資料
            teaorder.drinks = drinksData[teaIndex].name
            print("飲料品項：\(teaorder.drinks)")
            
            //容量資料
            if sizeSegmentedControl.selectedSegmentIndex == 0 {
                teaorder.size = "大杯"
            }else {
                teaorder.size = "中杯"
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
            
            //是否加珍珠
            if tapiocaSwitch.isOn {
               teaorder.tapioca = "要加"
            }else {
               teaorder.tapioca = "不加"
            }
            print("是否加購：\(teaorder.size)")
             
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
    
    //取得修改後的訂單內容
    func getEditOrder() {
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
                    teaorder.size = "大杯"
                }else {
                    teaorder.size = "中杯"
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
                
                //是否加珍珠
                if tapiocaSwitch.isOn {
                   teaorder.tapioca = "要加"
                }else {
                   teaorder.tapioca = "不加"
                }
                print("是否加購：\(teaorder.size)")
                 
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
    
    //點擊return收鍵盤
    @IBAction func closeKeyin(_ sender: Any) {
    }
    
    @IBAction func messageCloseKeyin(_ sender: Any) {
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
            let confirmOrder: [String : String] = ["name": teaorder.name, "drinks": teaorder.drinks, "size": teaorder.size, "sugar": teaorder.sugar.rawValue, "ice": teaorder.ice.rawValue, "tapioca": teaorder.tapioca, "price": teaorder.price, "message": teaorder.message]
            
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
    
    //傳送修改後的訂單資料至sheetDB
        func sendEditDrinksOrderToServer() {
            
                //PUT的API需要知道上傳的資料是什麼格式，所以依照API Documentation的規定設定
                let url = URL(string: "https://sheetdb.io/api/v1/co2xognew7ev0/name/\(teaorder.name)")
                var urlRequest = URLRequest(url: url!)
                // 上傳資料所以設定為PUT
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //PUT所提供的API，Value為物件的陣列（Array），所以利用Dictionary實作
                let confirmOrder: [String : String] = ["name": teaorder.name, "drinks": teaorder.drinks, "size": teaorder.size, "sugar": teaorder.sugar.rawValue, "ice": teaorder.ice.rawValue, "tapioca": teaorder.tapioca, "price": teaorder.price, "message": teaorder.message]
                
                //PUT API 需要在物件（Object）內設定key值為data, value為一個物件的陣列（Array）
                let postData: [String: Any] = ["data" : confirmOrder]
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: postData, options: []) // 將Data轉為JSON格式
                    let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in // 背景上傳資料
                        NotificationCenter.default.post(name: Notification.Name("waitMessage"), object: nil, userInfo: ["message": true])
                    }
                    task.resume()
                    NotificationCenter.default.post(name: Notification.Name("waitMessage"), object: nil, userInfo: ["message": false])
                    self.navigationController?.popViewController(animated: true) // 返回訂購頁面
                }
                catch{
                }
            }

   //傳送訂單資料至sheetDB
    @IBAction func confirmButton(_ sender: Any) {
        getOrder() //取得訂單資料
        sendDrinksOrderToServer() //傳送資料至sheetDB
        print("已新增") //檢查用
        return showAlertMessage(title: "訂購成功",message: "快去訂單明細檢查一下") //完成傳送提示訊息
    }
    
    //傳送修改後的訂單資料至sheetDB
    @IBAction func editconfirmButton(_ sender: Any) {
        getEditOrder() //取得修改後訂單資料
        sendEditDrinksOrderToServer() //傳送修改完成資料至sheetDB

        print("已完成修改") //檢查用
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
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
