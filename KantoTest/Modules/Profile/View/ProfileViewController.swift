//
//  ProfileViewController.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-28.
//

import UIKit
//import AVFoundation

protocol ExecuteTaskProtocol {
    func execute()
}


class ProfileViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameProfile: UITextField!
    @IBOutlet weak var userNameProfile: UITextField!
    @IBOutlet weak var biographyProfile: UITextView!
    
    
    //MARK: Propiedades
    var userData: User?
    var executeTaskDelegate: ExecuteTaskProtocol? = nil
    var wichIphoneIs: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.cornerRadius = (imageProfile.frame.size.width) / 2
        imageProfile.clipsToBounds = true
        
        
        //Name
        if UserDefaultsHelper.getData(type: String.self, forKey: .name) != nil {
            nameProfile.text = UserDefaultsHelper.getData(type: String.self, forKey: .name)
        } else {
            nameProfile.text = userData?.name
        }
        //UserName
        if UserDefaultsHelper.getData(type: String.self, forKey: .userName) != nil {
            userNameProfile.text = UserDefaultsHelper.getData(type: String.self, forKey: .userName)
        } else {
            userNameProfile.text = userData?.user_name
        }
        //Biography
        if UserDefaultsHelper.getData(type: String.self, forKey: .biography) != nil {
            biographyProfile.text = UserDefaultsHelper.getData(type: String.self, forKey: .biography)
        } else {
            biographyProfile.text = userData?.biography
        }
        //ImageProfile
        if UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile) != nil {
            imageProfile.image = UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile)
        } else {
            imageProfile.imageFrom(url: URL(string:(userData?.profilePicture)!)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        //Solo vamos a contemplar lo sugerido, iPhone 8 y X
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 1334:
                    print("iPhone 8")
                    self.wichIphoneIs = "iPhone8"
                    
                case 2436:
                    print("iPhone X")
                    self.wichIphoneIs = "iPhoneX"

                default:
                    print("Unknown")
                }
            }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    //MARK: Funciones
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if biographyProfile.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
            if self.wichIphoneIs == "iPhone8" {
                if userNameProfile.isFirstResponder {
                    self.view.frame.origin.y = -keyboardSize.height
                }
            }
            
        }
    }

    //MARK: Acciones
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        
        if nameProfile.text == "" || userNameProfile.text == "" || biographyProfile.text == "" {
            let refreshAlert = UIAlertController(title: "ERROR", message: "Hay campos vacíos, por favor complétalos", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in }))
            present(refreshAlert, animated: true, completion: nil)
            
        } else if nameProfile.text!.count < 4 {
            let refreshAlert = UIAlertController(title: "ERROR", message: "El nombre debe tenes más de 3 caracteres", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in }))
            present(refreshAlert, animated: true, completion: nil)
        } else if userNameProfile.text!.count < 3 {
            let refreshAlert = UIAlertController(title: "ERROR", message: "El user debe tenes más de 2 caracteres", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in }))
            present(refreshAlert, animated: true, completion: nil)
        } else if biographyProfile.text!.count < 20 {
            let refreshAlert = UIAlertController(title: "ERROR", message: "La biografía debe tenes más de 19 caracteres", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
        else {
            print("saving data...")
            UserDefaultsHelper.setData(value: nameProfile.text.self, key: .name)
            UserDefaultsHelper.setData(value: userNameProfile.text.self, key: .userName)
            UserDefaultsHelper.setData(value: biographyProfile.text.self, key: .biography)
            UserDefaultsHelper.saveImageInUserDefault(img: imageProfile.image!, key: .imageProfile)
            
            if self.executeTaskDelegate != nil {
                self.executeTaskDelegate?.execute()
            }
            
            self.dismiss(animated: true)
        }
        

    }
    
    @IBAction func changePhoto(_ sender: Any) {
        print("change photo...")
        
        let picker = UIImagePickerController()
        
        let refreshAlert = UIAlertController(title: "Opción", message: "Cómo desea cargar la foto?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Tomar una foto", style: .default, handler: { (action: UIAlertAction!) in
            picker.sourceType = .camera
            picker.cameraDevice = .front
            picker.delegate = self
            self.present(picker, animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Abrir la galería", style: .default, handler: { (action: UIAlertAction!) in
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true)
        }))

        present(refreshAlert, animated: true, completion: nil)

       
        
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.cornerRadius = (imageProfile.frame.size.width) / 2
        imageProfile.clipsToBounds = true
        imageProfile.image = image
    }
    
    
}
