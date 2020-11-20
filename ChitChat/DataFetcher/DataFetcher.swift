//
//  DataFetcher.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Firebase

class DataFetcher {
    let modelRef: DatabaseReference
    let queryRef: DatabaseQuery
    let id: String
    typealias completionHandler<T> = (_ result: Result<T>) -> Void
    
    init(modelRef: DatabaseReference, queryRef: DatabaseQuery, id: String) {
        self.modelRef = modelRef
        self.queryRef = queryRef
        self.id = id
    }
    
    convenience init() {
        self.init(modelRef: Constants.refs.ref, queryRef: Constants.refs.ref.queryOrderedByKey(), id: "")
    }
    
    
    func fetchData<T: SnapshotProtocol>(t: T.Type, startingAt startKey: Double?, orderedBy orderChild: String, andWithReturnCount count: Int, completion: @escaping completionHandler<[DataSnapshot]>) {
        
        var orderedQueryRef = queryRef.queryOrdered(byChild: orderChild)
        if startKey != nil {
            orderedQueryRef = queryRef.queryStarting(atValue: startKey)
        }
        orderedQueryRef = orderedQueryRef.queryLimited(toLast: UInt(count))
        
        
        orderedQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let objects = snapshot.children.allObjects as? [DataSnapshot], objects.isEmpty != true else {
                completion(.completed(nil)); return
            }
            completion(.success(objects))
        }
    }
    
    
    func fetchFromDatabase<T: SnapshotProtocol>(t: T.Type, ref: DatabaseReference, completion: @escaping(T?) -> Void) {
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else { completion(nil); return}
            let model = T.init(snapDict: dict, key: snapshot.key)
            completion(model)
        }
    }
}
