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
} 
