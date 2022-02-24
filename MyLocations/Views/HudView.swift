//
//  HudView.swift
//  MyLocations
//
//  Created by Lagash Systems on 20/03/2020.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import UIKit

class HudView: UIView {
    var text = ""
    
    class func hud(inView view: UIView,
                   animated:Bool) -> HudView{
        
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
      
        hudView.show(animated: animated)
        return hudView
    }
    
    override func draw(_ rect: CGRect) {
        
        let boxWith:CGFloat = 96
        let boxHeight:CGFloat = 96
        let boxRect = CGRect(x: round((bounds.size.width - boxWith) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWith, height: boxHeight)
        
        let roundeRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundeRect.fill()
        
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2),
                                     y: center.y - round(image.size.height / 2))
            image.draw(at: imagePoint)
        }
        
        let attribs = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                        NSAttributedString.Key.foregroundColor:UIColor.white]
        let textSize = text.size(withAttributes: attribs)
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                                y: center.y - round(textSize.height / 2 ) + boxHeight / 4)
        
        text.draw(at: textPoint, withAttributes: attribs)
        
        
    }
    func hide(){
        superview?.isUserInteractionEnabled = true
        removeFromSuperview()
    }

    func show(animated: Bool){
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [],animations: {
                self.alpha = 1
             
            self.transform = CGAffineTransform.identity }, completion: nil)
            
        }
    }
}
