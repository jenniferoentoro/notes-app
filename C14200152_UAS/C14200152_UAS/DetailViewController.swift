//
//  DetailViewController.swift
//  C14200152_UAS
//
//  Created by Jennifer on 19/12/2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var titleInput: UITextField!
    @IBOutlet var noteInput: UITextView!
    public var completion: ((String,String)-> Void)?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        titleInput.becomeFirstResponder()
        noteInput.layer.borderWidth = 1
        noteInput.layer.cornerRadius = 4
        noteInput.layer.borderColor = UIColor.lightGray.cgColor
//        titleInput.borderStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapSave(){
        if let text = titleInput.text,!text.isEmpty, !noteInput.text.isEmpty{
            completion?(text,noteInput.text)
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
