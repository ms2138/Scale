//
//  Record.swift
//  Scale
//
//  Created by mani on 2020-06-08.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

extension Record {
    func createdAtString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: createdAt)
    }
}
