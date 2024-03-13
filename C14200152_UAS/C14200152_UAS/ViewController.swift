//
//  ViewController.swift
//  C14200152_UAS
//
//  Created by Jennifer on 19/12/2022.
//

import UIKit
import Firebase
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    //variabel untuk menyimpan data yang dipanggil dari firebase
    var arrayTempIsi: [(id:String,title:String, note:String, jam:String, tanggal:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "My Notes"
        ref = Database.database(url: "https://c14200152-uasios-default-rtdb.firebaseio.com/").reference()
        
        readDB()
        
    }
    
    
 
    
    @IBAction func didTapNote(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "new") as? DetailViewController else{
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            let today = Date()
            let hours   = (Calendar.current.component(.hour, from: today))
            let minutes = (Calendar.current.component(.minute, from: today))
            let seconds = (Calendar.current.component(.second, from: today))
            let jamFix = "\(hours):\(minutes):\(seconds)"
            let date = (Calendar.current.component(.day, from: today))
            let month = (Calendar.current.component(.month, from: today))
            let year = (Calendar.current.component(.year, from: today))
            let tanggalFix = "\(date)-\(month)-\(year)"

            let val = [ "title": noteTitle, "isi": note,"jam" : jamFix, "tanggal" : tanggalFix]
            self.ref.child("detailNotes").childByAutoId().setValue(val)
          
            self.readDB()
           
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func readDB(){
        DispatchQueue.global().async{
         
            self.ref.child("detailNotes").observe(.value, with: { (snapshot) in
                if(snapshot.childrenCount > 0){
                    
                        let v = snapshot.value as! NSDictionary
                        print(v as Any)
                self.arrayTempIsi = []
                        for (k,j) in v {
                            var array = [String]()
                            array.append(k as! String)
                            for (_,n) in j as! NSDictionary {
                                array.append(n as! String)

                            }
                            self.arrayTempIsi.append((id:array[0],title:array[4],note: array[3],jam: array[1],tanggal:array[2]))
                           
                            array = [String]()
                        
                }
             
                self.checkKosong()
                self.table.reloadData()
                }else{
                    self.checkKosong()
                }
            })
        }
    }
    
    func checkKosong(){
     
        if (!arrayTempIsi.isEmpty){
            self.label.isHidden = true
            self.table.isHidden = false
        }else{
            self.label.isHidden = false
            self.table.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTempIsi.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! CustomTableViewCell
        cell.titleNote.text = arrayTempIsi[indexPath.row].title
        cell.isiNote.text = arrayTempIsi[indexPath.row].note
        cell.jam.text = arrayTempIsi[indexPath.row].jam
        cell.tanggal.text = arrayTempIsi[indexPath.row].tanggal
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = arrayTempIsi[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else{
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.note = model.note
        let jamTanggal = "\(model.tanggal) \(model.jam)"
        vc.tanggalJamString = jamTanggal
        
        
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            let today = Date()
            let hours   = (Calendar.current.component(.hour, from: today))
            let minutes = (Calendar.current.component(.minute, from: today))
            let seconds = (Calendar.current.component(.second, from: today))
            let jamFix = "\(hours):\(minutes):\(seconds)"
            let date = (Calendar.current.component(.day, from: today))
            let month = (Calendar.current.component(.month, from: today))
            let year = (Calendar.current.component(.year, from: today))
            let tanggalFix = "\(date)-\(month)-\(year)"
            let val = [ "title": noteTitle, "isi": note,"jam" : jamFix, "tanggal" : tanggalFix]
            
            self.ref.child("detailNotes").child(self.arrayTempIsi[indexPath.row].id).updateChildValues(val)
            self.arrayTempIsi = []
            self.readDB()
        }
        vc.delete = { deleteSignal in
            self.navigationController?.popToRootViewController(animated: true)
            self.ref.child("detailNotes").child(self.arrayTempIsi[indexPath.row].id).removeValue()
            self.arrayTempIsi = []
            self.readDB()
        }
        navigationController?.pushViewController(vc,animated:true)
    }
}
