//
//  keyChainClass.swift
//  keyChainLoginApp
//
//  Created by Konstantin on 28.10.2021.
//

import Foundation
import Security

class keyChainClass : NSObject {
    
    @discardableResult
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: "ROK1SMR.keyChainLoginApp",
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func getKeyChainData(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "ROK1SMR.keyChainLoginApp",
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        
        var dataTypeRef : AnyObject? = nil
        let status : OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            return dataTypeRef as! Data?
            
        } else {
            return nil
        }
    }
}
