//
//  SettingsModelController.swift
//  ChitChat
//
//  Created by ty foskey on 9/27/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SettingsModelController {
    
    let uid: String
    let dataFetcher: DataFetcher
    var nameChange = false
    var numberChange = false
    var profilePicChange = false
    var newName: String?
    var newNumber: String?
    var newImageData: Data!
    typealias SettingsResult = (Result<String?>) -> Void
    
    init(dataFetcher: DataFetcher) {
        uid = Auth.auth().currentUser!.uid
        self.dataFetcher = dataFetcher
    }
    
    func getCurrentUser(completion: @escaping(Users) -> Void) {
        let ref = Constants.refs.userRef.child(uid)
        dataFetcher.fetchFromDatabase(t: Users.self, ref: ref) { (user) in
            guard user != nil else { return }
            completion(user!)
        }
    }
    
    func updateSettings(completed: @escaping(SettingsResult)) {
        updateProfilePicStorage {[weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .error(let errorMessage):
                completed(.error(errorMessage))
                
            case .success(let imageUrl):
                var dict = [String:Any]()
                if imageUrl != nil {
                    dict.updateValue(imageUrl!, forKey: "profileUrl")
                }
                
                if strongSelf.newName != nil {
                    dict.updateValue(strongSelf.newName!, forKey: "name")
                }
                
                if strongSelf.newNumber != nil {
                    dict.updateValue(strongSelf.newNumber!, forKey: "number")
                }
                
                Constants.refs.userRef.child(strongSelf.uid).updateChildValues(dict)
                completed(.success("Success"))
                
                
            default: break
            }
        }
    }
    
    private func updateProfilePicStorage(completion: @escaping(SettingsResult)) {
        guard profilePicChange == true else { completion(.success(nil)) ; return }
        let profileImageChild = "profile_image"
        let storageRef = Constants.storageConfig.storageRef.child(profileImageChild).child(uid)
        
        storageRef.putData(newImageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(.error("Error inputing profile pic"))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    completion(.error("Error downloading url"))
                    return
                }
                
                let profileImageUrl = url?.absoluteString
                completion(.success(profileImageUrl))
            }
        }
    }
    
}
