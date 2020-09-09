// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation
import ConsistencyManager

/**
 This type alias creates a `WeakSharedCollectionArray` type which holds `SharedCollections`.
 */
typealias WeakSharedCollectionArray = AnyWeakArray<WeakSharedCollectionBox>

/**
 This defines a WeakHolder which specifically holds a SharedCollection.
 This is useful because WeakBox<SharedCollection> is illegal in Swift. You need a concrete type like this one.
 */
struct WeakSharedCollectionBox: WeakHolder {
    weak var element: SharedCollection?
}
