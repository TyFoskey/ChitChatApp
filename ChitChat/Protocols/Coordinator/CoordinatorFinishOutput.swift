//
//  CoordinatorFinishOutput.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

protocol CoordinatorFinishOutput {
    var finishFlow: ((Any?) -> Void)? { get set }
}
