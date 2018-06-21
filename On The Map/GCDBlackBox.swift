//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by atao1 on 3/15/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
