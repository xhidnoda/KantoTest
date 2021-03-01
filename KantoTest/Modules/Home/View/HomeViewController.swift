//
//  HomeViewController.swift
//  KantoTest
//
//  Created by Alejandro Ferreira on 2021-02-26.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: CustomTableView!
    @IBOutlet weak var stackViewProfile: UIStackView!
    @IBOutlet weak var nombreProfile: UILabel!
    @IBOutlet weak var EditProfile: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewProfile: Gradient!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var userNameProfile: UILabel!
    @IBOutlet weak var bioProfile: UILabel!
    @IBOutlet weak var followersProfile: UILabel!
    @IBOutlet weak var followedProfile: UILabel!
    @IBOutlet weak var viewsProfile: UILabel!
    
    
    //MARK: Propiedades
    let maxHeaderHeight: CGFloat = 360
    let minHeaderHeight: CGFloat = 40
    var previousScrollOffset: CGFloat = 0
    var userData: User?
    var grabacionesDataList: [GrabacionesList] = []
    var controller = HomeController()
    var currentlyPlayingIndexPath : IndexPath? = nil
    var currentlyPlayingIndexPathRow = 0
    var isOKtoPlayVideo = false
    var cantidadLikes: Int?

    
    override func viewWillAppear(_ animated: Bool) {
        //UserData
        print("viewWillAppear HomeViewController")
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
            bioProfile.text = UserDefaultsHelper.getData(type: String.self, forKey: .biography)
        } else {
            bioProfile.text = userData?.biography
        }
        //ImageProfile
        if UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile) != nil {
            imageProfile.image = UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile)
        } else {
            imageProfile.imageFrom(url: URL(string:(userData?.profilePicture)!)!)
        }
        
        followersProfile.text = String(userData!.followers!)
        followedProfile.text = String(userData!.followed!)
        viewsProfile.text = String((userData?.views)!)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        //Set View
        viewProfile.clipsToBounds = true
        viewProfile.layer.cornerRadius = 20
        viewProfile.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imageProfile.layer.borderWidth = 1.0
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.white.cgColor
        imageProfile.layer.cornerRadius = (imageProfile.frame.size.width) / 2
        imageProfile.clipsToBounds = true
        nombreProfile.isHidden = true
        
        //Obtenemos los datos de las grabaciones.
        retriveUserData()
        
    }
    
    
    //MARK: Funciones
    func retriveUserData() {
        controller.getGrabacionesList { (grabacionesList) in
            self.grabacionesDataList = grabacionesList
            //UserDefaultsHelper.setData(value: self.grabacionesDataList.self, key: .userDataGrabaciones)
            self.tableView.reloadData()
        }
    }
    
    //MARK: Acciones
    @IBAction func editProfile(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "pause"), object: nil)
        let storyboard = UIStoryboard(name: "ProfileView", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        controller?.userData = self.userData
        controller?.executeTaskDelegate = self
        self.present(controller!, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.grabacionesDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (UINib(nibName: "ItemListaViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ItemListaViewCell)!
        cell.saberQueCellToqueDelegate = self
        
        if self.grabacionesDataList.count > 0 {
            cell.loadData(grabacion: self.grabacionesDataList[indexPath.row], index: indexPath.row)
            
            //Load video cell here
            let avPlayer = AVPlayer(url: URL(string:(self.grabacionesDataList[indexPath.row].record_video)!)!)
            cell.videoView.playerLayer.player = avPlayer
            let castedLayer = cell.videoView.layer as! AVPlayerLayer
            castedLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            castedLayer.player = avPlayer
            
            
            if self.currentlyPlayingIndexPathRow == indexPath.row && self.isOKtoPlayVideo {
                cell.videoView.player?.play()
            } else {
                cell.videoView.player?.pause()
                cell.imageControl.image = UIImage(systemName: "play.circle")
            }
            
        }
        
        return cell
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let location = scrollView.panGestureRecognizer.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            print("could not specify an indexpath")
            return
        }

        print("scrollViewDidEndDragging at row \(indexPath.row)")
        self.currentlyPlayingIndexPathRow = indexPath.row
        self.isOKtoPlayVideo = true
        print("value scrolling: \(scrollView.contentOffset.y)")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeViewController {
    func canAnimateHeader (_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerViewHeight.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    func setScrollPosition() {
        self.tableView.contentOffset = CGPoint(x:0, y: 0)
    }
}
extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = (scrollView.contentOffset.y - previousScrollOffset)
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        if canAnimateHeader(scrollView) {
            var newHeight = headerViewHeight.constant
            if isScrollingDown {
                newHeight = max(minHeaderHeight, headerViewHeight.constant - abs(scrollDiff))
                if headerViewHeight.constant == 40 {
                    self.stackViewProfile.backgroundColor = UIColor.black
                    self.nombreProfile.isHidden = false
                }

            } else if isScrollingUp {
                newHeight = min(maxHeaderHeight, headerViewHeight.constant + abs(scrollDiff))
                if headerViewHeight.constant > 90 {
                    self.stackViewProfile.backgroundColor = UIColor.clear
                    self.nombreProfile.isHidden = true
                }
            }
            if newHeight != headerViewHeight.constant {
                headerViewHeight.constant = newHeight
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
            }
        }
    }
}


extension HomeViewController: SaberQueCellToqueProtocol {
    func didTapButtonInside(cell: ItemListaViewCell) {
        let index = tableView.indexPath(for: cell)
        print("La celda que toque es: \((index?.row)!) y la cantidad de like es: \((cell.grabaciones?.likes)!) y el userName es \((cell.grabaciones?.user?.user_name)!)")
        self.cantidadLikes = (cell.grabaciones?.likes)! + 1

        if UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayPositionLikes) != nil {
            var position = UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayPositionLikes)!
            position.append(index!.row)
            UserDefaultsHelper.setData(value: position, key: .arrayPositionLikes)
        } else {
            UserDefaultsHelper.setData(value: [index!.row], key: .arrayPositionLikes)
        }
        
        if UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayValuesLikes) != nil {
            var value = UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayValuesLikes)!
            value.append(self.cantidadLikes!)
            UserDefaultsHelper.setData(value: value, key: .arrayValuesLikes)
        } else {
            UserDefaultsHelper.setData(value: [self.cantidadLikes!], key: .arrayValuesLikes)
        }
        
        let dic = Dictionary(uniqueKeysWithValues: zip(UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayPositionLikes)!,UserDefaultsHelper.getData(type: [Int].self, forKey: .arrayValuesLikes)!))
        
        UserDefaults.standard.set(object: dic, forKey: "dictionaryLikes")
        print("El diccionario es: \(dic)")
    }
}

extension HomeViewController: ExecuteTaskProtocol {
    func execute() {
        
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
            bioProfile.text = UserDefaultsHelper.getData(type: String.self, forKey: .biography)
        } else {
            bioProfile.text = userData?.biography
        }
        //ImageProfile
        if UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile) != nil {
            imageProfile.image = UserDefaultsHelper.getImageFromUserDefault(key: .imageProfile)
        } else {
            imageProfile.imageFrom(url: URL(string:(userData?.profilePicture)!)!)
        }
        
    }
    
    
}

