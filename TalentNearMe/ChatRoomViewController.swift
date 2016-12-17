//
//  ChatRoomViewController.swift
//  TalentNearMe
//
//  Created by M.A.D. Crew. on 21/10/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation
import FirebaseRemoteConfig

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clientTable: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    //Initialization for Firebase database
    var ref: FIRDatabaseReference!
    
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 100
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    var remoteConfig: FIRRemoteConfig!
    
    
    
    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        let data = [MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.clientTable.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        let name = message[MessageFields.name] as String!
        print("the name is \(name)")
        
        let text = message[MessageFields.text] as String!
        print("the text is \(text)")
        
        cell.textLabel?.text = name! + ": " + text!
        
        return cell
    }
    
    
    @IBAction func sendButton(_ sender: AnyObject) {
        textFieldShouldReturn(textField)
        
    }
    
    
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        
        mdata[MessageFields.name] = self.myName
        
        // Push data to Firebase Database
        self.ref.child("Message/\(Manager.autoChatRoomName)/Chat").childByAutoId().setValue(mdata)
        //self.ref = FIRDatabase.database().reference(withPath:       "Message/Chat")
        //self.ref.setValue(mdata)
    }
    
    var uid = ""
    var uidToDisplay = ""
    var myName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        self.uidToDisplay = Manager.messageText
        print("UISTODISPLAY is \(self.uidToDisplay)")
        
        
        //拿 UID
        if let user = FIRAuth.auth()?.currentUser {
            
            uid = user.uid  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            // No user is signed in.
        }
        
        FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Real-Name").observe(.value, with: { (snapshot) in
            if let chatPerson = snapshot.value{
                self.myName = chatPerson as! String
            }
        })
        
        /*
        FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/ChatList/\(self.uidToDisplay)").observe(.value, with: { (snapshot) in
            if let chatRoomNumber = snapshot.value{
                Manager.autoChatRoomName = chatRoomNumber as! String
                print("manager autoname is \(chatRoomNumber)")
            }
        })
        */
        self.title = Manager.chatRoomRealName
        
        
        configureDatabase()
        
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Message/\(Manager.autoChatRoomName)/Chat").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    deinit {
        self.ref.child("Message/\(Manager.autoChatRoomName)/Chat").removeObserver(withHandle: _refHandle)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msglength.intValue // Bool
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPopUp(_ sender: AnyObject) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessCardPopUpID") as! BasicContactViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
}

