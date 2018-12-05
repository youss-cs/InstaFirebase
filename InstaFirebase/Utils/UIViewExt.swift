//
//  UIViewExt.swift
//  InstaFirebase
//
//  Created by YouSS on 12/5/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let left = left { leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true }
        if let right = right { trailingAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true }
        if width != 0 { widthAnchor.constraint(equalToConstant: width).isActive = true }
        if height != 0 { heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
}
