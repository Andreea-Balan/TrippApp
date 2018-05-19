//
//  CustomSearchBar.swift
//  TravelApp
//
//  Created by Demo on 5/9/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 5.0,y: 5.0,width: frame.size.width - 10.0,height: frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            //searchField.font = preferredFont
            searchField.textColor = UIColor.black
            
            // Set the background color of the search field.
            searchField.backgroundColor = UIColor.white
        }
        
       /* let startPoint = CGPoint(x: 0.0,y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width,y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
 
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(red:0.63, green:0.82, blue:0.82, alpha:1.0).cgColor
        shapeLayer.lineWidth = 2.5

        
        layer.addSublayer(shapeLayer) */
        
        super.draw(rect)
    }
    
    
    
    init(frame: CGRect , textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        // println(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0]
        
        for (i, subview) in searchBarView.subviews.enumerated() {
            if subview.isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
}
