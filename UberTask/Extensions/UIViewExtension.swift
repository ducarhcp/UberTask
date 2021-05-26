//
//  UIViewExtension.swift
//  UberTask
//
//  Created by Dusan Mitrasinovic on 5/25/21.
//

import UIKit

extension UIView {
    
    func roundCornersClipped() {
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
}
