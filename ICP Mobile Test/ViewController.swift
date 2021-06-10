//
//  ViewController.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tfUsernameLogin : UITextField!
    @IBOutlet weak var tfPasswordLogin : UITextField!
    @IBOutlet weak var btnLogin : UIButton!
    var vSpinner : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundButtonLogin(button: btnLogin)
        
        hideKeyboardWhenTappedAround()
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

    @IBAction func didLogin(){
        showSpinner(onView: self.view)
        let stringUrl = "https://test.incenplus.com/users/login"
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let params = [
            "username" : tfUsernameLogin.text!,
            "password" : tfPasswordLogin.text!
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
                            self.removeSpinner()
                            if let data = json["data"] as? [String : Any]{
                                let preferences = UserDefaults.standard

                                let userTokenKey = "token"
                                let userTokenPref = data["token"] as? String

                                preferences.set(userTokenPref, forKey: userTokenKey)

                                //Save to disk
                                let didSave = preferences.synchronize()

                                if !didSave {
                                    print("iduser tidak tersimpan")
                                }
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let goToHomeView = storyBoard.instantiateViewController(withIdentifier: "homeView")
                                goToHomeView.modalPresentationStyle = .fullScreen
                                self.present(goToHomeView, animated: true, completion: nil)
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
    
    func roundButtonLogin(button : UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(thumbsUpButtonPressedLogin), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func thumbsUpButtonPressedLogin() {
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
