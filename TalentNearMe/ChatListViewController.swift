//
//  SecondViewController.swift
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


class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var uid = ""
    var uidToDisplay = ""
    
    var chatListAccount = ""
    var chatListName = ""
    var chatPersonName = ""
    
    var avengers = ["李語堂","PeterChou","李俊賢"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        //拿 UID
        if let user = FIRAuth.auth()?.currentUser {
            
            uid = user.uid  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            // No user is signed in.
        }
        
/*
        FIRDatabase.database().reference().child("ID/\(self.uid)/Profile/ChatList").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for child in snapshots {
                    
                    //好友uid
                    self.chatListAccount = child.key
                    print("交流紀錄 ChatListAccount is \(self.chatListAccount)")
                    
                    //聊天室名稱
                    self.chatListName = child.value as! String
                    print("交流紀錄 ChatListName is \(self.chatListName)")
                    
                    FIRDatabase.database().reference(withPath: "ID/\(self.chatListAccount)/Profile/Real-Name").observe(.value, with: { (snapshot) in
                        if let chatPerson = snapshot.value{
                            self.chatPersonName = chatPerson as! String
                            
                            self.avengers.append(chatPerson as! String)
                            
                            self.tableView.reloadData()
                        }
                    })
                    
                    
                }
            }
        })
        
        */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        print(indexPath.row)
        cell.textLabel?.text = avengers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Manager.messageText = "0qyJLm5UV6cdoK2K5IOFrfXMhgv1"
        performSegue(withIdentifier: "ourSegue", sender: avengers[indexPath.row])
    }
    

    
}

