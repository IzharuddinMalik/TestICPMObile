//
//  TambahBukuViewController.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit
import Alamofire

class TambahBukuViewController : UIViewController {
    
    var tokenUser : String = ""
    var vSpinner : UIView?
    @IBOutlet weak var tfNamaBuku : UITextField!
    @IBOutlet weak var tfDescBuku : UITextField!
    @IBOutlet weak var btnTambahBuku : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        roundButtonTambahBuku(button: btnTambahBuku)
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
    
    @IBAction func tambahBuKu(){
        showSpinner(onView: self.view)
        let preferences = UserDefaults.standard
        let userTokenKey = "token"
        
        if preferences.object(forKey: userTokenKey) == nil {
            
        } else{
            let userTokenPref = preferences.string(forKey: userTokenKey)
            tokenUser = userTokenPref!
            print("IDUSERPREF \(userTokenKey)")
        }
        
        let stringUrl = "https://test.incenplus.com/books/insert?token=" + tokenUser
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let params = [
            "name" : tfNamaBuku.text!,
            "description" : tfDescBuku.text!
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
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let goToHomeView = storyBoard.instantiateViewController(withIdentifier: "homeView")
                            goToHomeView.modalPresentationStyle = .fullScreen
                            self.present(goToHomeView, animated: true, completion: nil)
                            
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
    
    func roundButtonTambahBuku(button : UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(thumbsUpButtonPressedTambahBuku), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func thumbsUpButtonPressedTambahBuku() {
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

@IBDesignable class CVTambahBuku: UIView {
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

