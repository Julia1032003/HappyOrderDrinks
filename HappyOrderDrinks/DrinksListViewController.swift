//
//  DrinksListViewController.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/22.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class DrinksListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var drinksListTableView: UITableView!
    @IBOutlet var numberOfDrinksLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    
    
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
    
    //刪除cell資料
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let drinks = ListArray[indexPath.row]
        deleteOrderList(ListArray: drinks)
        ListArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        updatePriceUI()
        updateOrdersUI()
    }
    
    //修改cell資料
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showedit", sender: indexPath)
    }
    
    
    //畫面載入，取得訂單資料
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoadingList()
        drinksListTableView.delegate = self
        drinksListTableView.dataSource = self
        getOrderList()
        // Do any additional setup after loading the view.
    }
    
    //開始載入動畫
    func startLoadingList(){
        loadingActivityIndicator.startAnimating()
    }
    
    //停止載入動畫
    func stopLoadingList(){
        loadingActivityIndicator.stopAnimating()
    }
    
    //取得sheetDB訂單資料
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

                        
                        // 更新TableView，UI的更新必須在Main thread
                        DispatchQueue.main.async {
                            self.stopLoadingList() //停止Loading動畫並且關閉圖示
                            self.loadingActivityIndicator.alpha = 0
                            self.drinksListTableView.reloadData() // 更新訂購表
                            self.updateOrdersUI() // 更新訂購數量
                            self.updatePriceUI() // 更新總價
                        }
                    }
                }
                task.resume() // 開始在背景下載資料
    }
    
    //刪除sheetDB訂單資料
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
    
     //修改cell資料，將飲料訂單cell裡的資料存到下一頁的訂購飲料頁面
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if let controller = segue.destination as? OrderDrinksTableViewController, let row = drinksListTableView.indexPathForSelectedRow?.row  {
           let editOrderData = ListArray[row]
           controller.editOrderData = editOrderData
            
        }
    }
    
    override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                    // Dispose of any resources that can be recreated.
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
