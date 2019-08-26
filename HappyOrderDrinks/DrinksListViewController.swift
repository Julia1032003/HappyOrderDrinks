//
//  DrinksListViewController.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/22.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

struct Order:Encodable {
    var drinksdata:DrinksInformation
}


class DrinksListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var drinksListTableView: UITableView!
    @IBOutlet var numberOfDrinksLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    var ListArray = [DrinksInformation]()
        
    //訂單總金額統計
    func updatePriceUI() {
                var price = 0
                
                for i in 0 ..< ListArray.count {
                    if let money = Int(ListArray[i].price){
                        price += money
                    }
                }
                totalPriceLabel.text = "\(price)"
            }
    
    //訂單總杯數統計
    func updateOrdersUI(){
            numberOfDrinksLabel.text = "\(ListArray.count)"
            }

            
    //得到要顯示的Cell，設定Cell的內容
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let information = ListArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderformcell", for: indexPath) as? DrinksTableViewCell
        else {
            return UITableViewCell()
        }
        cell.cellinformation = information
        cell.updateUI(id: indexPath.row)
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let drinks = ListArray[indexPath.row]
        //let deletePrince = (ListArray[indexPath.row].price)
        deleteOrderList(ListArray: drinks)
        ListArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        updatePriceUI()
        updateOrdersUI()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        drinksListTableView.delegate = self
        drinksListTableView.dataSource = self
        getOrderList()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
    
    //取得訂單資料
    func getOrderList(){
                let urlStr = "https://sheetdb.io/api/v1/co2xognew7ev0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // 將網址轉換成URL編碼（Percent-Encoding）
                let url = URL(string: urlStr!) // 將字串轉換成url
                
                // 背景抓取飲料訂單資料
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    if let data = data, let content = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: Any]]{
                        // 因為資料的Json的格式為陣列（Array）包物件（Object），所以[[String: Any]]
                        
                        for order in content {
                            if let data = DrinksInformation(json: order){
                                self.ListArray.append(data)
                            }
                        }

                        
                        // UI的更新必須在Main thread
                        DispatchQueue.main.async {
                            //更新TableView
                            self.drinksListTableView.reloadData()    // 更新訂購表
                            self.updateOrdersUI() // 更新訂購數量
                            self.updatePriceUI() // 更新總價
                        }
                    }
                }
                task.resume() // 開始在背景下載資料
    }
    
    func deleteOrderList(ListArray:DrinksInformation){
       if let urlStr = "https://sheetdb.io/api/v1/co2xognew7ev0/name/\(ListArray.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("applicatino/json", forHTTPHeaderField: "Content-Type")
            let List = Order(drinksdata: ListArray)
            let jsonEncoder = JSONEncoder()
            if let data = try? jsonEncoder.encode(List){
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data){(retData,response, error)in
                    let decoder = JSONDecoder()
                    if let retData = retData , let dic = try? decoder.decode([String:Int].self, from:retData),dic["deleted"] == 1{
                        print("Successfully deleted")
                    }else{
                        print("Failed to delete")
                    }
                }
                task.resume()
            }else{
                print("Delete")
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
