//
//  Result.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

enum Result<T> {
    case error(String)
    case completed(Double?)
    case success(T)
}
