//
//  SplashScreenViewController.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-27.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //MARK: Propiedades
    var homeController = HomeController()
    var hasDataUser = false
    var hasDataGrabacionesList = false
    var userData: User?
    var grabacionesDataList: [GrabacionesList] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        retriveData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.startAnimating()
    }
    
    
    
    //MARK: Funciones
    func retriveData() {
        homeController.getUserData { (userData) in
            self.activity.stopAnimating()
            let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "HomeView") as? HomeViewController else {
                print("This means you haven't set your view controller identifier properly.")
                return
            }
            guard let navigationController = self.navigationController else {
                print("This means you current view controller doesn't have a navigation controller")
                return
            }
            controller.userData = userData
            navigationController.pushViewController(controller, animated: true)
        }
        
    }

   

}
