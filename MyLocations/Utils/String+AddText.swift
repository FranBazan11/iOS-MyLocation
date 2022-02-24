//
//  String+AddText.swift
//  MyLocations
//
//  Created by francisco bazan on 4/1/20.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separetedBy separator: String) {
        if text != nil {
            if !isEmpty {
                self += separator
            }
        }
        self += text ?? ""
    }
}
