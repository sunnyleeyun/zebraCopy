//
//  PopUpViewController.swift
//  TalentNearMe
//
//  Created by M.A.D. Crew. on 21/10/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BasicContactViewController: UIViewController {

    @IBOutlet weak var BasicContact_Name: UILabel!
    
    @IBOutlet weak var BasicContact_JobDescription: UILabel!
    
    @IBOutlet weak var BasicContact_Line: UIImageView!
    
    @IBOutlet weak var BasicContact_SelfIntroduction: UITextView!
    
    @IBAction func BasicContact_SeeMore_Button_Tapped(_ sender: AnyObject) {
        
        Manager.UID_of_Friend = self.uidToDisplay
        
        
    }
    
    
    var chatListAccount = ""
    var chatListName = ""
    var childByAutoid_Has_Been_Set = false
    var autoConfirm = false
    
    
    @IBAction func BasicContact_StartChatting_Button_Tapped(_ sender: UIButton) {
        
        FIRDatabase.database().reference(withPath: "Message").childByAutoId().child(self.uid).setValue(self.uidToDisplay)
        
        FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/ChatList").childByAutoId().setValue(self.uidToDisplay)
        
        FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/ChatList").childByAutoId().setValue(self.uid)
        
        
        /*
 FIRDatabase.database().reference().child("Message").observe(.value, with: { snapshott in
            
            if let snapshotts = snapshott.value as? [String:AnyObject] {
                
                for childd in snapshotts{
                    
                    print("child.value is \(childd.value)")

                    
                    if childd.key == self.uid{
                        
                        print("child.value is \(childd.value)")
                        
                    }
                }
            }
        })
        

        
        FIRDatabase.database().reference().child("ID/\(self.uid)/Profile/ChatList").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for child in snapshots {
                    
                    // 亂數
                    self.chatListAccount = child.key
                    print("ChatListAccount is \(self.chatListAccount)")
                    
                    
                    // 好友uid
                    self.chatListName = child.value as! String
                    print("chatListName is \(self.chatListName)")
                    
                    
                    
                    //如果chatlistAccount != uidToDisplay
                    //if self.chatListName != self.uidToDisplay{
                        
                        
                        //if self.childByAutoid_Has_Been_Set == false {
                            
                            //self.childByAutoid_Has_Been_Set = true
                            
                            
                            //  Message/childByAutoID/uid/uidToDisplay
                            FIRDatabase.database().reference(withPath: "Message").childByAutoId().child(self.uid).setValue(self.uidToDisplay)
                            
                            
                            FIRDatabase.database().reference().child("Message").observe(.value, with: { snapshott in
                                
                                if let snapshotts = snapshott.value as? [String:AnyObject] {
                                    
                                    for childd in snapshotts{
                                        
                                        
                                        if childd.key == self.uid{
                                            
                                            print("child.value is \(childd.value)")

                                        }
                                        
                                        
                                        //儲存在Manager裡面，亂碼聊天室
                                        Manager.autoChatRoomName = childd.key
                                        print("manager autochatroomname is \(Manager.autoChatRoomName)")
                                        
                                        
                                        
                                        //設在uid裏頭ChatList
                                        FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/ChatList/\(self.uidToDisplay)").setValue(childd.key)
                                        
                                        //設在uidToDisplay裏頭ChatList
                                        FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/ChatList/\(self.uid)").setValue(childd.key)
                                        
                                        
                                    }
                                    
                                }
                            })
                            

                        //}
                        
                        
                        
                        
                        
                    //}
                    
                    /*else if self.chatListAccount == self.uidToDisplay{
                        
                        FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/ChatList/\(self.uidToDisplay)").observe(.value, with: { (snapshot) in
                            if let chatRoom = snapshot.value{
                                Manager.autoChatRoomName = chatRoom as! String
                                print("chatRoom is \(chatRoom)")
                                
                            }
                        })
                        
                    }*/
                    
                    
                    
                    

                    
                }
            }
            
        })
        
    */
    }
    
    var uid = ""
    var uidToDisplay = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        //記得名字在Manager
        FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/Real-Name").observe(.value, with: { (snapshot) in
            if let Name = snapshot.value{
                Manager.chatRoomRealName = Name as! String
                print("name is \(Name)")
            }
        })
        
        
        
        //Retrieve data from Firebase database
        var ref = FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/Real-Name")
        ref.observe(.value, with: { snapshot in (self.BasicContact_Name.text = snapshot.value as! String)
            })
        
                
        //Retrieve data from Firebase database
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/Job-Description")
        ref.observe(.value, with: { snapshot in (self.BasicContact_JobDescription.text = snapshot.value as! String)
        })
        
        
        //Retrieve data from Firebase database
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uidToDisplay)/Profile/Self-Introduction")
        ref.observe(.value, with: { snapshot in (self.BasicContact_SelfIntroduction.text = snapshot.value as! String)
        })
      
        
        
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        
        self.removeAnimate()
        //self.view.removeFromSuperview()
        
    }
    
    
    func showAnimate(){
        
        self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            
        })
        
    }
    
    func removeAnimate(){
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
            }, completion: {(finished : Bool) in
                if (finished){
                    
                    
                    self.view.removeFromSuperview()
                    
                }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
