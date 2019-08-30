//
//  DrinksStoreMap.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/29.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotation : NSObject , MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordingnate:CLLocationCoordinate2D){
        self.coordinate = coordingnate
    }
}

