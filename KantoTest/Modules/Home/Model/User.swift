//
//  User.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-25.
//

import Foundation


class User: Codable {
    var user_id_encrypted: String?
    var name: String?
    var user_name: String?
    var profilePicture: String?
    var biography: String?
    var followers: Int?
    var followed: Int?
    var views: Int?
}



//{
// "user_id_encrypted":"22f3%$%$jh#H2",
// "name":"TestAndroide",
// "user_name":"@testotesto",
// "profilePicture":"https://ks-profiles-dev.s3.amazonaws.com/media/user_photos/2949/tempImage1578523169147.png",
// "biography": "Esta es mi biografía",
// "followers": 25,
// "followed": 150,
// "views": 18345
//}
