//
//  CameraViewController.swift
//  TalentNearMe
//
//  Created by Daphne Jiang on 09/12/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import FirebaseAuth


class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var PickedImage: UIImageView!
    var uid = ""
    
    //拍照功能
    @IBAction func CameraButtonAction(_ sender: UIButton) {
        
        print("PICRUE")
        
        var imagePicker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker, animated: true, completion: {})
            } else {
                print("Rear camera doesn't exist")
            }
        } else {
            print("Camera inaccessable")
        }
        
        
        
        
        
    }
    
    //瀏覽相簿功能
    @IBAction func GalleryButtonAction(_ sender: UIButton) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    //上傳功能
    @IBAction func UploadButtonAction(_ sender: UIButton) {
        
        
        // 將照片上傳到Firebase Storage
        let ImageData = UIImageJPEGRepresentation(PickedImage.image!,0.6 )
        _ = UIImage(data: ImageData!)
        
        let data: NSData = ImageData! as NSData
        
        let storage = FIRStorage.storage()
        
        let storageRef = storage.reference(forURL: "gs://github-zebra.appspot.com/")
        //let imageRef = storageRef.child("images/\(FIRAuth.auth()!.currentUser!.uid)/(UserProfile)")
        let imageRef = storageRef.child("\(self.uid)/UserProfile.jpg")
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        _ = imageRef.put(data as Data, metadata: nil) { metaData , error in
            if (error != nil){
                print("Oh!NO")
            }else{
                print("success")
            }
            
        }

        
        
    }
    
    //儲存相片功能
    @IBAction func SaveButtonAction(_ sender: UIButton) {
        
        let imageData = UIImageJPEGRepresentation(PickedImage.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage! , nil, nil, nil)
        saveNotice()
        
    }
    
    @IBAction func Confirm_Button_Tapped(_ sender: UIButton) {
        
        //Open UpdateAccountInfoViewController
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateAccountInfoViewControllerID") as! UpdateAccountInfoViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    
    //儲存提醒
    func saveNotice(){
        let alertController = UIAlertController(title: "Image Saved", message: "你的照片已儲存", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK" , style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    //相片擷取
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            PickedImage.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //帳號UID設定
        if let user = FIRAuth.auth()?.currentUser{
            uid = user.uid
        }else{
            
        }

        // Do any additional setup after loading the view.
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
