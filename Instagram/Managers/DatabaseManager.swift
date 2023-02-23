//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-22.
//

import Foundation
import FirebaseFirestore


final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    public func createUser(newUser: User, completion: @escaping (Bool) -> Void) {
        // Create a reference to a document with a particular path
        // Document/subcollection/submaterial
        let reference = database.document("users/\(newUser.username)")
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
//        let data = ["username": newUser.username]
        
        // Any Data is set to Firebase is Dictionary
        // Find the way to convert all data, that put to Firebase to Dictionary -> Extensions/ func asDictionary()
        reference.setData(data) { error in
           completion(error == nil)
        }
    }
} 
