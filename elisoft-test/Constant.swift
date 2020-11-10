//
//  Constant.swift
//  elisoft-test
//
//  Created by Mark G on 09/11/2020.
//

import UIKit

struct Constant {
    static let size = CGSize(width: 7, height: 10)
    static let maximum = 140
    static var numberPerPage: Int {
        Int(size.width * size.height)
    }
    
    static let spacing: CGFloat = 2
}
