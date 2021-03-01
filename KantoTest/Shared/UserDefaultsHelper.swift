//
//  UserDefaultsHelper.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-28.
//

import Foundation
import UIKit

enum UserDefaultKeys: String, CaseIterable {
 case name
 case userName
 case biography
 case darLike
 case imageProfile
 case arrayPositionLikes
 case arrayValuesLikes
 case dictionaryLikes
}

final class UserDefaultsHelper {
    
    static func setData<T>(value: T, key: UserDefaultKeys) {
       let defaults = UserDefaults.standard
       defaults.set(value, forKey: key.rawValue)
    }
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
       let defaults = UserDefaults.standard
       let value = defaults.object(forKey: forKey.rawValue) as? T
       return value
    }
    static func removeData(key: UserDefaultKeys) {
       let defaults = UserDefaults.standard
       defaults.removeObject(forKey: key.rawValue)
    }
    
    static func saveImageInUserDefault(img:UIImage, key:UserDefaultKeys) {
        UserDefaults.standard.set(img.pngData(), forKey: key.rawValue)
    }

    static func getImageFromUserDefault(key:UserDefaultKeys) -> UIImage? {
        let imageData = UserDefaults.standard.object(forKey: key.rawValue) as? Data
        var image: UIImage? = nil
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }
        return image
    }
    
}
