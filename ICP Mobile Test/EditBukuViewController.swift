//
//  EditBukuViewController.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit
import Alamofire

class EditBukuViewController : UIViewController {
    
    var tokenUser : String = ""
    @IBOutlet weak var tfEditNamaBuku : UITextField!
    @IBOutlet weak var tfEditDescBuku : UITextField!
    @IBOutlet weak var btnEditBuku : UIButton!
    var vSpinner : UIView?
    var idBuku : String = ""
    var editNamaBuku : String = ""
    var editDescBuku : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundButtonEditBuku(button: btnEditBuku)
        hideKeyboardWhenTappedAround()
        
        getDetailBook()
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
    
    func getDetailBook(){
//        showSpinner(onView: self.view)
        let preferences = UserDefaults.standard
        let userTokenKey = "token"
        
        if preferences.object(forKey: userTokenKey) == nil {
            
        } else{
            let userTokenPref = preferences.string(forKey: userTokenKey)
            tokenUser = userTokenPref!
            print("IDUSERPREF \(userTokenKey)")
        }
        
        let stringUrl = "https://test.incenplus.com/books/detail"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        print("IDBOOK \(idBuku)")

        let params = [
            "id" : idBuku,
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
                            if let data = json["data"] as? [String : Any] {
                                self.tfEditNamaBuku.text = data["name"] as? String
                                self.tfEditDescBuku.text = data["description"] as? String
                            }
//                            self.removeSpinner()
                            
                        } else {
                            print("response error \(json["message"])")
                            let alert = UIAlertController(title: "Gagal", message: json["description"] as? String, preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: nil))

                            self.present(alert, animated: true)
//                            self.removeSpinner()
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
    
    @IBAction func editBuku(){
        showSpinner(onView: self.view)
        let preferences = UserDefaults.standard
        let userTokenKey = "token"
        
        if preferences.object(forKey: userTokenKey) == nil {
            
        } else{
            let userTokenPref = preferences.string(forKey: userTokenKey)
            tokenUser = userTokenPref!
            print("IDUSERPREF \(userTokenKey)")
        }
        
        let stringUrl = "https://test.incenplus.com/books/edit?token=" + tokenUser
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        print("IDBOOK \(idBuku)")
        print("NAMEBOOKEDIT \(tfEditNamaBuku.text)")
        print("DESCBOOKEDIT \(tfEditDescBuku.text)")

        let params = [
            "id" : idBuku,
            "name" : tfEditNamaBuku.text!,
            "description" : tfEditDescBuku.text!
        ]
        
        AF.request(URL.init(string: stringUrl)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
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
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let goToHomeView = storyBoard.instantiateViewController(withIdentifier: "homeView")
                            goToHomeView.modalPresentationStyle = .fullScreen
                            self.present(goToHomeView, animated: true, completion: nil)
                            self.removeSpinner()
                            
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
    
    @IBAction func kembali(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let goToHomeView = storyBoard.instantiateViewController(withIdentifier: "homeView")
        goToHomeView.modalPresentationStyle = .fullScreen
        self.present(goToHomeView, animated: true, completion: nil)
    }
    
    func roundButtonEditBuku(button : UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(thumbsUpButtonPressedEditBuku), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func thumbsUpButtonPressedEditBuku() {
        print("thumbs up button pressed")
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

@IBDesignable class CVEditBuku: UIView {
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
