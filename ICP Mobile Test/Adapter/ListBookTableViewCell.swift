//
//  ListBookTableViewCell.swift
//  ICP Mobile Test
//
//  Created by MacBook on 6/10/21.
//

import UIKit

struct BookListObject {
    let idBookList : String
    let createdAt : Int
    let createdByName : String
    let description : String
    let modifiedAt : Int
    let modifiedByName : String
    let bookName : String
    
    init(idBookList : String, createdAt : Int, createdByName : String, description : String, modifiedAt : Int, modifiedByName : String, bookName : String) {
        self.idBookList = idBookList
        self.createdAt = createdAt
        self.createdByName = createdByName
        self.description = description
        self.modifiedAt = modifiedAt
        self.modifiedByName = modifiedByName
        self.bookName = bookName
    }
}

protocol DetailBookDelegate : AnyObject {
    func didDetailBook(with idBook : String)
}

class ListBookTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBookName : UILabel!
    @IBOutlet weak var lblBookDesc : UILabel!
    @IBOutlet weak var lblBookCreatedAt : UILabel!
    @IBOutlet weak var lblBookCreatedByName : UILabel!
    @IBOutlet weak var lblBookModifiedAt : UILabel!
    @IBOutlet weak var lblBookModifiedByName : UILabel!
    
    static let identifier = "ListBookTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ListBookTableViewCell", bundle: nil)
    }
    
    var idBookList : String = ""
    var nameBookList : String = ""
    var descBookList : String = ""
    var detailBookDelegate : DetailBookDelegate?
    
    func configurationBook(with idBook : String, bookName : String, bookDesc : String, bookCreatedAt : Int, bookCreatedByName : String, bookModifiedCreatedAt : Int, bookModifiedByName : String){
        
        let truncatedTime = Int(bookCreatedAt / 1000)
        let date = Date(timeIntervalSinceNow: TimeInterval(truncatedTime))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "HH:mm:ss"
        self.lblBookCreatedAt.text = formatter.string(from: date)
        
        let truncatedTime2 = Int(bookModifiedCreatedAt / 1000)
        let date2 = Date(timeIntervalSinceNow: TimeInterval(truncatedTime2))
        let formatter2 = DateFormatter()
        formatter2.timeZone = TimeZone(abbreviation: "UTC")
        formatter2.dateFormat = "HH:mm:ss"
        self.lblBookModifiedAt.text = formatter2.string(from: date2)
        
        self.idBookList = idBook
        self.nameBookList = bookName
        self.descBookList = bookDesc
        self.lblBookName.text = bookName
        self.lblBookDesc.text = bookDesc
        self.lblBookCreatedByName.text = bookCreatedByName
        self.lblBookModifiedByName.text = bookModifiedByName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didPressDetail(){
        detailBookDelegate?.didDetailBook(with: idBookList)
    }
    
}
