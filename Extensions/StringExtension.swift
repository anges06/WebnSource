//
//  StringExt.swift
//  WebnSource
//
//  Created by anges on 25.02.19.
//  Copyright © 2019 anges. All rights reserved.
//

import Foundation

//Not required - prepared for future functionality
extension String{
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
}
