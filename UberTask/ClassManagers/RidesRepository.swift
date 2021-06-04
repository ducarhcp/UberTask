//
//  RidesRepository.swift
//  UberTask
//
//  Created by Dusan Mitrasinovic on 5/28/21.
//

import UIKit
import Foundation

class RidesRepository: NSObject {
    let rides: [Ride] = [Ride(carImage: UIImage(named: "black_car")!, dropoffTime: "06:30", totalAmount: 54.5),
                         Ride(carImage: UIImage(named: "green_car")!, dropoffTime: "09:40", totalAmount: 32.5),
                         Ride(carImage: UIImage(named: "black_car")!, dropoffTime: "06:30", totalAmount: 39.6),
                         Ride(carImage: UIImage(named: "black_car")!, dropoffTime: "06:30", totalAmount: 87.5),
                         Ride(carImage: UIImage(named: "green_car")!, dropoffTime: "06:30", totalAmount: 87.5),
                         Ride(carImage: UIImage(named: "black_car")!, dropoffTime: "06:30", totalAmount: 87.5)
    ]
    
    let sections = ["Popular", "Economy", "Premium"]
}

