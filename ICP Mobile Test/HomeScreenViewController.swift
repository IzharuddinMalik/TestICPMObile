//
//  HomeScreenViewController.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit
import Alamofire

class HomeScreenViewController : UIViewController {
    
    @IBOutlet weak var tableListBook : UITableView!
    @IBOutlet weak var btnTambahBuku : UIButton!
    var tokenUser : String = ""
    var createdByName : String = ""
    var modifiedByName : String = ""
    var vSpinner : UIView?
    
    var listBook : [BookListObject] = []
    var idBookList : String = ""
    var modifiedAt : Int = 0
    var createdAtBookName : String = ""
    var modifiedAtBookName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundButtonTambahBuku(button: btnTambahBuku)
        showSpinner(onView: self.view)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.tableListBook?.register(ListBookTableViewCell.nib(), forCellReuseIdentifier: ListBookTableViewCell.identifier)
            self.getListBook()
            self.tableListBook.delegate = self
            self.tableListBook.dataSource = self
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
    
    func getListBook(){
                
        let preferences = UserDefaults.standard
        let userTokenKey = "token"
        
        if preferences.object(forKey: userTokenKey) == nil {
            
        } else{
            let userTokenPref = preferences.string(forKey: userTokenKey)
            tokenUser = userTokenPref!
            print("IDUSERPREF \(userTokenKey)")
        }
        
        let stringUrl = "https://test.incenplus.com/books"
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
                                print("ARRAYBOOK \(dataBook["books"])")
                                if let arrayBook = dataBook["books"] as? [[String : Any]]{
                                    for dict in arrayBook {
                                        guard
                                            
                                            let getIdBook = dict["id"] as? String,
                                            let getBookName = dict["name"] as? String,
                                            let getCreatedAt = dict["createdAt"] as? Int,
                                            let getModifiedAt = dict["modifiedAt"] as? Int,
                                            let getBookDesc = dict["description"] as? String
                                        else {
                                            print("error parsing \(dict)")
                                            continue
                                        }
                                        
                                        if getIdBook == "null"{
                                            self.idBookList = "-"
                                            print("IDBOOKLISTNULL \(self.idBookList)")
                                        } else {
                                            self.idBookList = getIdBook
                                            print("IDBOOKLISTNOTNULL \(self.idBookList)")
                                        }
                                        
                                        if String(getModifiedAt) == "null" {
                                            self.modifiedAt = 0
                                        } else {
                                            self.modifiedAt = getModifiedAt
                                        }
                                        
                                        if let createdAtBook = dict["createdBy"] as? [String : Any]{
                                            self.createdAtBookName = createdAtBook["fullname"] as! String
                                            if self.createdAtBookName == "null" {
                                                self.createdByName = "-"
                                            } else {
                                                self.createdByName = self.createdAtBookName
                                            }
                                            
                                            print("CREATEDBYNAME \(createdAtBook["fullname"] as! String)")
                                        }
                                        
                                        if let modifiedAtBook = dict["modifiedBy"] as? [String : Any]{
                                            
                                            self.modifiedAtBookName = modifiedAtBook["fullname"] as! String
                                            if self.modifiedAtBookName == "null" {
                                                self.modifiedByName = "-"
                                            } else {
                                                self.modifiedByName = self.modifiedAtBookName
                                            }
                                            
                                            print("MODIFIEDBYNAME \(modifiedAtBook["fullname"] as! String)")
                                        }
                                        
                                        print("BOOKIDLIST \(getIdBook)")
                                        
                                        self.listBook.append(BookListObject(idBookList: self.idBookList, createdAt: getCreatedAt, createdByName: self.createdByName, description: getBookDesc, modifiedAt: self.modifiedAt, modifiedByName: self.modifiedByName, bookName: getBookName))
                                        
                                        print("LIST OF SIZE \(self.listBook.count)")
                                    }
                                }
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
    
    func roundButtonTambahBuku(button : UIButton){
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(thumbsUpButtonPressedTambahBuku), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func thumbsUpButtonPressedTambahBuku() {
        print("thumbs up button pressed")
    }
    
    @IBAction func tambahBuku() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let goToTambahBuku = storyBoard.instantiateViewController(withIdentifier: "tambahBukuView")
        goToTambahBuku.modalPresentationStyle = .fullScreen
        self.present(goToTambahBuku, animated: true, completion: nil)
    }
    
}

extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("LIST OF SIZE TABLE \(listBook.count)")
        return listBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: ListBookTableViewCell.identifier, for: indexPath) as! ListBookTableViewCell
        
        customCell.detailBookDelegate = self
        
        let book = listBook[indexPath.row]
        print("BOOKID \(book.idBookList)")
        customCell.configurationBook(with: book.idBookList, bookName: book.bookName, bookDesc: book.description, bookCreatedAt: book.createdAt, bookCreatedByName: book.createdByName, bookModifiedCreatedAt: book.modifiedAt, bookModifiedByName: book.modifiedByName)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension HomeScreenViewController : DetailBookDelegate {
    
    func didDetailBook(with idBook: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let goToEditBuku = storyBoard.instantiateViewController(withIdentifier: "editBukuView") as! EditBukuViewController
        goToEditBuku.idBuku = idBook
        goToEditBuku.modalPresentationStyle = .fullScreen
        self.present(goToEditBuku, animated: true, completion: nil)
    }
}
