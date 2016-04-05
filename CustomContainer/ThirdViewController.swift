//
//  ThirdViewController.swift
//  CustomContainer
//
//  Created by yangyu on 16/3/22.
//  Copyright © 2016年 YangYiYu. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, CircleViewProtocol {

    lazy var maskLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.blackColor().CGColor
        layer.path = self.circlePath.CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowOpacity = 1

        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.mask = self.maskLayer
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.upToFill()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
