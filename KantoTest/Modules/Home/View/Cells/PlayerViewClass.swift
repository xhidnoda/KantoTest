//
//  PlayerViewClass.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-27.
//

import UIKit
import AVKit

class PlayerViewClass: UIView {

    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer?{
        get{
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

}
