//
//  GrabacionesList.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-25.
//

import Foundation


class GrabacionesList: Codable {
    var user: User?
    var songName: String?
    var record_video: String?
    var preview_img: String?
    var likes: Int?
}






//{
//   "user": {
//     "name": "TestAndroide",
//     "user_name": "@testotesto",
//     "profilePicture": "https://ks-profiles-dev.s3.amazonaws.com/media/user_photos/2949/tempImage1578523169147.png"
//   },
//   "songName": "Secreto",
//   "record_video": "https://s3.amazonaws.com/ks-records-test/media/records/2990/3654c78e9e_video_mixed.mp4",
//   "preview_img": "https://s3.amazonaws.com/ks-records-test/media/records/3346/fff3c44ef3_img.jpg",
//   "likes": 25
// }
