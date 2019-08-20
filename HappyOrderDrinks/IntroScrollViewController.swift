//
//  IntroScrollViewController.swift
//  HappyOrderDrinks
//
//  Created by Julia Wang on 2019/8/16.
//  Copyright © 2019 Julia Wang. All rights reserved.
//

import UIKit

class IntroScrollViewController: UIViewController , UIScrollViewDelegate{

    
    @IBOutlet var drinksImageView: [UIImageView]!
    @IBOutlet var drinksScrollView: UIScrollView!
    @IBOutlet var drinksPageControl: UIPageControl!
    @IBOutlet var drinksView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinksScrollView.delegate = self
        drinksPageControl.numberOfPages = 13
        drinksPageControl.currentPage = 0

        // Do any additional setup after loading the view.
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(drinksScrollView.contentOffset.x / drinksScrollView.frame.size.width)
        
        drinksPageControl.currentPage = currentPage
    }

}
