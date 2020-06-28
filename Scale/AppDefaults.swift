//
//  AppDefaults.swift
//  Scale
//
//  Created by mani on 2020-06-27.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class AppDefaults {
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    var firstTimeLaunched: Bool {
        get {
            return defaults.bool(forKey: Constants.firstTimeLaunched)
        }
        set {
            defaults.set(newValue, forKey: Constants.firstTimeLaunched)
        }
    }
    var unitOfWeight: UnitOfWeight {
        get {
            return UnitOfWeight(rawValue: defaults.integer(forKey: Constants.unitOfWeight)) ?? UnitOfWeight.pounds
        }
        set {
            defaults.set(newValue.rawValue, forKey: Constants.unitOfWeight)
        }
    }
}
