//
//  Extentions.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 9/13/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension String {
    // Return true if the string contains only alphabets, numbers, and underscores, false otherwise
    func isAlphanumeric() -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z0-9_]+").evaluate(with: self)
    }
}
