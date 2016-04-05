//
//  CircleViewController.swift
//  CustomContainer
//
//  Created by yangyu on 16/3/22.
//  Copyright © 2016年 YangYiYu. All rights reserved.
//

import UIKit

protocol BackToRootProtocol: class {
    
    var backButton: UIButton {get}
    
    func backToRoot() -> ()
}

protocol CircleViewProtocol: class {
   
    var maskLayer: CAShapeLayer {get}
    var circlePath: UIBezierPath {get}
    var rectPath: UIBezierPath {get}
    var animationBlock: ((UIView) -> ())?{get}
    
    func upToFill() -> ()
    func downToCircle() -> ()
    
}

extension CircleViewProtocol where Self: UIViewController {
    
    var animationBlock: ((UIView) -> ())? {
        
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController as? CircleViewController {
            return rootController.changePostionOfOtherViews
        }
        return nil
    }
    
    var circlePath: UIBezierPath {
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 30))
        path.addQuadCurveToPoint(CGPoint(x: UIScreen.mainScreen().bounds.width, y: 30), controlPoint: CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: -20))
        path.addLineToPoint(CGPoint(x: UIScreen.mainScreen().bounds.width, y: UIScreen.mainScreen().bounds.height))
        path.addLineToPoint(CGPoint(x: 0.0, y: UIScreen.mainScreen().bounds.height))
        path.closePath()
        
        return path
    }
    
    var rectPath: UIBezierPath {
        
        let rect = UIApplication.sharedApplication().keyWindow?.rootViewController?.view.convertRect(self.view.bounds, toView: UIApplication.sharedApplication().keyWindow?.rootViewController?.view)
        
        let path = UIBezierPath(rect: rect!)
        
        return path
    }
    
    func upToFill() {
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.duration = 1
        animation.toValue = self.rectPath.CGPath
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.maskLayer.addAnimation(animation, forKey: nil)
        
        UIView.animateWithDuration(1) {
            self.view.center = (UIApplication.sharedApplication().keyWindow?.rootViewController?.view.center)!
        }
        
        if let block = animationBlock {
            block(self.view)
        }
    }
    
    func downToCircle() {
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.duration = 1
        animation.toValue = self.circlePath.CGPath
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.maskLayer.addAnimation(animation, forKey: nil)
        
    }
}

class CircleViewController: UIViewController, BackToRootProtocol {
    
    lazy var containerView: UIView = {
    
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.colorWithCGFloat(49.0, g: 55.0, b: 74.0)
        return view;
    }()
    
    lazy var titleLabel: UILabel = {
    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
        label.center = CGPoint(x: self.view.center.x, y: 30)
        label.font = UIFont.boldSystemFontOfSize(26)
        label.textColor = UIColor.whiteColor()
        label.text = "首页"
        label.textAlignment = .Center
        return label
    }()
    
    lazy var backButton: UIButton = {
    
        let button: UIButton = UIButton(type: .Custom)
        button.frame = CGRect(x: 10, y: 10, width: 60, height: 40)
        button.setImage(UIImage.init(named: "hamburger") , forState: .Normal)
        button.addTarget(self, action: #selector(backToRoot), forControlEvents: .TouchUpInside)
        button.alpha = 0
        return button
    }()
    
    var selectedViewIndex: Int = 0
    
    let colors = [UIColor.colorWithCGFloat(231.0, g: 205.0, b: 71.0), UIColor.colorWithCGFloat(246.0, g: 113.0, b: 54.0), UIColor.colorWithCGFloat(247.0, g: 171.0, b: 130.0), UIColor.colorWithCGFloat(242.0, g: 113.0, b: 85.0), UIColor.colorWithCGFloat(196.0, g: 71.0, b: 105.0)]
    
    let viewControllerNames = ["CustomContainer.FirstViewController", "CustomContainer.SecondViewController", "CustomContainer.ThirdViewController", "CustomContainer.ForthViewController", "CustomContainer.FifthViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLabel)
        self.view.addSubview(self.backButton)
        
        var i = 0
        
        let viewControllers = viewControllerNames.flatMap({ (name: String) -> UIViewController? in
            
            if let viewController = NSClassFromString(name) as? UIViewController.Type {
                let controller = viewController.init(nibName:
                    nil, bundle: nil)
                controller.view.backgroundColor = colors[i]
                
                i += 1
                return controller
            }else {
                i += 1
                return nil
            }
        })
        
        for i in 0..<viewControllers.count {
            
            let viewController = viewControllers[i]
            if viewController is CircleViewProtocol {
                viewController.view.frame = CGRect(x: 0.0, y: 120.0 + 120.0 * CGFloat(i), width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
                
                self.addChildViewController(viewController)
            }
        }
    }

    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        self.containerView.addSubview(childController.view)
        childController.didMoveToParentViewController(self)
    }
}

extension CircleViewController {
    
    func changePostionOfOtherViews(view: UIView) {
        
        if let viewIndex = self.containerView.subviews.indexOf(view) {
            
            self.selectedViewIndex = viewIndex
            
            for i in (viewIndex + 1)..<self.containerView.subviews.count {
                
                let singleView = self.containerView.subviews[i]
                
                let down_Y: CGFloat = 120.0 + 120.0 * CGFloat(i + 1) + singleView.bounds.height
                
                UIView.animateWithDuration(1, animations: {
                    singleView.center = CGPoint(x: singleView.center.x, y:down_Y)
                    self.backButton.alpha = 1
                })
            }
            
            for i in 0 ..< viewIndex {
                
                let singleView = self.containerView.subviews[i]
                
                let up_Y: CGFloat = singleView.center.y - (120.0 + 120.0 * CGFloat(i)) / 2
                
                UIView.animateWithDuration(1, animations: {
                    singleView.center = CGPoint(x: singleView.center.x, y:up_Y)
                    self.backButton.alpha = 1
                })
            }

        }
    }
    
    func backToRoot() {
        
        for i in 0 ..< self.containerView.subviews.count {
            
            let singleView = self.containerView.subviews[i]
            
            let down_Y: CGFloat = 120.0 + 120.0 * CGFloat(i - 1) + singleView.bounds.height / 2
            
            let selectedVC = self.childViewControllers[self.selectedViewIndex - 1]
        
            if let viewController = selectedVC as? CircleViewProtocol {
            
                viewController.downToCircle()
            
            }
            
            UIView.animateWithDuration(1, animations: {
                singleView.center = CGPoint(x: singleView.center.x, y:down_Y)
                self.backButton.alpha = 0
            })
        }
    }
}

extension UIColor {
    
    class func colorWithCGFloat(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        
        return UIColor(red: r / 256.0, green: g / 256.0, blue: b / 256.0, alpha: 1)
        
    }
    
}







