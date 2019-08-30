//
//  ViewController.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/16.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet var drinksStoreMKView: MKMapView!
    
   
    func showDrinksStorePoint(){
        let location = CLLocation(latitude: 25.051138, longitude: 121.534933)
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            drinksStoreMKView.setRegion(region, animated: true)
        let annotation = MyAnnotation(coordingnate: location.coordinate)
        annotation.title = "可不可熟成紅茶"
        annotation.subtitle = "台北伊通店"
        drinksStoreMKView.addAnnotation(annotation)
        
        
    }
    
    @IBAction func callActionButton(_ sender: Any) {
        let controller = UIAlertController(title: "可不可熟成紅茶-台北伊通店", message: "確定要打電話嗎？", preferredStyle: .actionSheet)
        let phoneNumber = "0225175510"
        let phoneAction = UIAlertAction(title: "打電話給\(phoneNumber)" , style: .default){(_) in
            if let url = URL(string: "tel:\(phoneNumber)"){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url,options: [:], completionHandler: nil)
                }else{
                    print("無法開啟URL")
                }
            }
            print("撥出成功")
        }
            
           
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(phoneAction)
        controller.addAction(cancelAction)
        present(controller,animated: true ,completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDrinksStorePoint()
        // Do any additional setup after loading the view.
        
    }
    
       
    
}

