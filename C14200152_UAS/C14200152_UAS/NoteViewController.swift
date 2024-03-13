//
//  NoteViewController.swift
//  C14200152_UAS
//
//  Created by Jennifer on 19/12/2022.
//

import UIKit

class NoteViewController: UIViewController {
    public var completion: ((String,String)-> Void)?
    public var delete: ((Bool)-> Void)?
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var noteText : UITextView!
    @IBOutlet var tanggaljam: UILabel!
    
    
    public var noteTitle : String = ""
    public var note : String = ""
    public var tanggalJamString : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = noteTitle
        noteText.text = note
        tanggaljam.text = tanggalJamString
        titleText.becomeFirstResponder()
        noteText.layer.borderWidth = 1
        noteText.layer.cornerRadius = 4
        noteText.layer.borderColor = UIColor.lightGray.cgColor
        var image = UIImage(named: "trash")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave)),
            UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete))
                                              
            
        ]
        
    }
    
    @objc func didTapDelete(){
        
            delete?(true)
        
    }
    
    @objc func didTapSave(){
        if let text = titleText.text,!text.isEmpty, !noteText.text.isEmpty{
            completion?(text,noteText.text)
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
