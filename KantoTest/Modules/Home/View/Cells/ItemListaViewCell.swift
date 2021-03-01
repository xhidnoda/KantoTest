//
//  ItemListaViewCell.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-25.
//

import UIKit
import AVKit

protocol SaberQueCellToqueProtocol {
    func didTapButtonInside(cell: ItemListaViewCell)
}


class ItemListaViewCell: UITableViewCell {

    @IBOutlet weak var viewContentALL: UIView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var imagenProfile: UIImageView!
    @IBOutlet weak var videoView: PlayerViewClass!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var imageControl: UIImageView!
        
    //MARK: Propiedades
    var saberQueCellToqueDelegate: SaberQueCellToqueProtocol? = nil
    var grabaciones: GrabacionesList?
    var cantidadLikes: Int?
    var grabacionesList: [GrabacionesList] = []
    let arrayValuesLikes = UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayValuesLikes)

    override func awakeFromNib() {
        super.awakeFromNib()
        imagenProfile.layer.masksToBounds = false
        imagenProfile.layer.borderColor = UIColor.white.cgColor
        imagenProfile.layer.cornerRadius = (imagenProfile.frame.size.width) / 2
        imagenProfile.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: NSNotification.Name(rawValue: "pause"), object: nil)
        
    }
    

    //MARK: Funciones
    @objc func pause() {
        videoView.player?.pause()
    }
    
    func loadData(grabacion: GrabacionesList, index: Int){
        
        grabaciones = grabacion
        let nameBold = grabacion.user?.name
        let sangNormal  = "sang"
        let songNameBold  = grabacion.songName

        let attributedString = NSMutableAttributedString(string:sangNormal)
        let attributedSpace = NSMutableAttributedString(string:" ")
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        let boldString = NSMutableAttributedString(string: nameBold!, attributes:attrs)
        let boldString2 = NSMutableAttributedString(string: songNameBold!, attributes:attrs)

        boldString.append(attributedSpace)
        boldString.append(attributedString)
        boldString.append(attributedSpace)
        boldString.append(boldString2)
        
        nombre.attributedText = boldString
        imagenProfile.imageFrom(url: URL(string:(grabacion.user?.profilePicture)!)!)

        if UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayPositionLikes) != nil {
            if (UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayPositionLikes)?.contains(index))! {
                let testFromDefaults = UserDefaults.standard.object([Int: Int].self, with: "dictionaryLikes")
                likes.text = "\((testFromDefaults![index])!) likes"
                buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                buttonLike.tintColor = UIColor.red
            } else {
                likes.text = "\(grabacion.likes!) likes"
            }
        } else {
            likes.text = "\(grabacion.likes!) likes"
        }
    }
    
    @IBAction func darLike(_ sender: Any) {
        if saberQueCellToqueDelegate != nil {
            saberQueCellToqueDelegate?.didTapButtonInside(cell: self)
        }
        buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        buttonLike.tintColor = UIColor.red
        cantidadLikes = grabaciones!.likes! + 1
        likes.text = "\(cantidadLikes!) likes"

    }
    
    
}
