//
//  DetailedContactViewController.swift
//  TalentNearMe
//
//  Created by M.A.D. Crew. on 23/10/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices
import FirebaseStorage
import FirebaseStorageUI

class DetailedContactViewController: UIViewController {

    @IBOutlet weak var DetailedContact_ProfilePicture: UIImageView!
    
    @IBOutlet weak var DetailedContact_Name: UILabel!
    
    @IBOutlet weak var DetailedContact_JobDescription: UILabel!
    
    @IBOutlet weak var DetailedContact_LearningPlan: UILabel!
    
    @IBOutlet weak var DetailedContact_SelfIntroduction: UILabel!
    
    
    var uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //拿 UID
        if let user = FIRAuth.auth()?.currentUser {
            
            uid = user.uid  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            // No user is signed in.
        }
        
        // Do any additional setup after loading the view.
        
        //Retrieve data from Firebase database
        var ref = FIRDatabase.database().reference(withPath: "ID/\(Manager.UID_of_Friend)/Profile/Real-Name")
        ref.observe(.value, with: { snapshot in (self.DetailedContact_Name.text = snapshot.value as! String)
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(Manager.UID_of_Friend)/Profile/Job-Description")
        ref.observe(.value, with: { snapshot in (self.DetailedContact_JobDescription.text = snapshot.value as! String)
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(Manager.UID_of_Friend)/Profile/Learning-Goal")
        ref.observe(.value, with: { snapshot in (self.DetailedContact_LearningPlan.text = snapshot.value as! String)
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(Manager.UID_of_Friend)/Profile/Self-Introduction")
        ref.observe(.value, with: { snapshot in (self.DetailedContact_SelfIntroduction.text = snapshot.value as! String)
        })
        
        
        // Points to the root reference
        let storageRef = FIRStorage.storage().reference(forURL: "gs://github-zebra.appspot.com/")
        
        // Points to "images"
        let imagesRef = storageRef.child(Manager.UID_of_Friend)
        
        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = "UserProfile.jpg"
        let spaceRef = imagesRef.child(fileName)
        
        // File path is "images/space.jpg"
        let path = spaceRef.fullPath
        
        // File name is "space.jpg"
        let name = spaceRef.name
        
        
        
        // Reference to an image file in Firebase Storage
        let reference = FIRStorage.storage().reference(forURL: "gs://github-zebra.appspot.com/\(Manager.UID_of_Friend)/UserProfile.jpg")
        
        reference.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                //print(error)
                
                print("CAN'T DO IT")
            } else {
                print("DID IT")
                let myImage: UIImage! = UIImage(data: data!)
                self.DetailedContact_ProfilePicture.image = myImage
            }
        }
        
        // UIImageView in your ViewController
        //var imageView: UIImageView = ...;
        
        // Load the image using SDWebImage
       // DetailedContact_ProfilePicture.sd_setImage(with: reference.child(Manager.UID_of_Friend), placeholderImage: UIImage(named: "UserProfile.jpg"))
        
        print("NAME is now \(name)")
        
        // Points to "images"
        //let imagesRef = spaceRef.parent()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
