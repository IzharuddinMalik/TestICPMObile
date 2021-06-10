//
//  ProfileViewController.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit
import Alamofire

class ProfileViewController : UIViewController {
    
    var tokenUser : String = ""
    @IBOutlet weak var lblUsernameProfile : UILabel!
    @IBOutlet weak var lblFullnameProfile : UILabel!
    @IBOutlet weak var btnLogout : UIButton!
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileUser()
        roundButtonLogout(button: btnLogout)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func getProfileUser(){
        
        showSpinner(onView: self.view)
        
        let preferences = UserDefaults.standard
        let userTokenKey = "token"
        
        if preferences.object(forKey: userTokenKey) == nil {
            
        } else{
            let userTokenPref = preferences.string(forKey: userTokenKey)
            tokenUser = userTokenPref!
            print("IDUSERPREF \(userTokenKey)")
        }
        
        let stringUrl = "https://test.incenplus.com/users/me"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        print("USERTOKEN \(tokenUser)")

        let params = [
            "token" : tokenUser
        ]

        AF.request(URL.init(string: stringUrl)!, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            print(response.result)

            switch response.result {

            case .success(_):
                if response.value != nil
                {
                    let itemObject = response.value as? [String : Any]
                    
                    if let json = itemObject {
                        let success = json["status_code"] as? Int
                        print("value success \(success)")
                        if success == 200 {
                            self.removeSpinner()
                            if let dataBook = json["data"] as? [String : Any] {
                                self.lblUsernameProfile.text = dataBook["username"] as? String
                                self.lblFullnameProfile.text = dataBook["fullname"] as? String
                            }
                        } else {
                            print("response error \(json["message"])")
                            let alert = UIAlertController(title: "Gagal", message: json["description"] as? String, preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: nil))

                            self.present(alert, animated: true)
                            self.removeSpinner()
                        }
                    }
                    
                }
                break
            case .failure(let error):
                print("error \(error)")
                break
            }
        }
    }
    
    func roundButtonLogout(button : UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(thumbsUpButtonPressedLogout), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func thumbsUpButtonPressedLogout() {
        print("thumbs up button pressed")
    }
    
    @IBAction func logout(){
        let preferences = UserDefaults.standard
        let tokenUserKey = "token"
        
        preferences.removeObject(forKey: tokenUserKey)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let logout = storyBoard.instantiateViewController(withIdentifier: "loginView")
        logout.modalPresentationStyle = .fullScreen
        present(logout, animated: true, completion: nil)
    }
}
@IBDesignable class CVProfile: UIView {
    var cornnerRadius : CGFloat = 10
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 5
    
    var shadowOpacity : CGFloat = 0
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
