//
//  addSightDelegate.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 1/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import Foundation

protocol AddSightDelegate: AnyObject {
    func addSight(newSight : Place) -> Bool
}
