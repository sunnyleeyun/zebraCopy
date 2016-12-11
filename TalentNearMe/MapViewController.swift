//
//  FirstViewController.swift
//  TalentNearMe
//
//  Created by M.A.D. Crew. on 21/10/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    
    var uid = ""
    
    //Initialization for Firebase database
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var Contact_Info_Tab: UIView!
    
    @IBOutlet weak var Contact_Info_Tab_Picture: UIImageView!
    
    @IBOutlet weak var Contact_Info_Tab_Name: UILabel!
    
    @IBOutlet weak var Contact_Info_Tab_Job: UILabel!
    
    
    //Setting the properties of annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is PinAnnotation {
            
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            if #available(iOS 9.0, *) {
                
                pinAnnotationView.pinTintColor = .purple
                
            } else {
                
                // Fallback on earlier versions
                
            }
            
            
            
            
            /* ///// Reserved for possible later usage part 1/2  (with Callout) /////
             pinAnnotationView.isDraggable = false
             pinAnnotationView.canShowCallout = true
             //pinAnnotationView.animatesDrop = true
             pinAnnotationView.image = UIImage(named: "Man_1")
             
             
             let profile_picture = UIImageView()
             profile_picture.image = UIImage(named: "Man_1")
             profile_picture.frame.size.width = 44
             profile_picture.frame.size.height = 44
             profile_picture.backgroundColor = UIColor.clear
             
             
             
             let detail = UIButton(type: UIButtonType.custom)
             detail.frame.size.width = 44
             detail.frame.size.height = 44
             detail.backgroundColor = UIColor.blue
             detail.setImage(UIImage(named: "dots"), for: .normal)
             
             
             pinAnnotationView.leftCalloutAccessoryView = profile_picture
             pinAnnotationView.rightCalloutAccessoryView = detail
             /////////// */
            
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    @IBOutlet weak var my_Location_Button: UIButton!
    
    var numberCounter = 0
    @IBAction func my_Location_Button_Tapped(_ sender: UIButton) {
        
        numberCounter = numberCounter + 1
        
        if numberCounter % 2 == 0 {
            
            if numberCounter > 999 {
                
                numberCounter = 2
                
            }
            
            mapShouldBeCentered = false
            
            my_Location_Button.setImage(UIImage(named: "My_Location_OFF"), for: .normal)
            
            
        } else if numberCounter % 2 == 1 {
            
            if numberCounter > 999 {
                
                numberCounter = 1
                
            }
            
            mapShouldBeCentered = true
            
            my_Location_Button.setImage(UIImage(named: "My_Location_ON"), for: .normal)
            
        }
        
    }
    
    //Decides what happens when an annotation is selected
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        Contact_Info_Tab_Name.isHidden = false
        Contact_Info_Tab_Job.isHidden = false
        
        
        //Subtitle was stored like this: "Job_Title, UID"
        if let Subtitle_And_UID_To_Be_Parsed = (view.annotation?.subtitle)! {
            
            let parsedSubtitle_Array = Subtitle_And_UID_To_Be_Parsed.characters.split{$0 == "," || $0 == "\r\n"}.map(String.init)
            
            //Store the UID of the user we decided to pin to Manager, so that BasicContactViewController could access it
            Manager.messageText = parsedSubtitle_Array[1]
            print("Manger is holdin UID: \(Manager.messageText)")
            
            Contact_Info_Tab_Job.text = parsedSubtitle_Array[0]
                        print("Contact is holdin Job: \(parsedSubtitle_Array[0])")
        }
        
        if let name = (view.annotation?.title)! {
            
            Contact_Info_Tab_Name.text = name
        }
        
        //Contact_Info_Tab_Picture.image = UIImage(named: "ManIcon")
        
        
        //Change Picture
        // Points to the root reference
        let storageRef = FIRStorage.storage().reference(forURL: "gs://github-zebra.appspot.com/")
        
        // Points to "images"
        let imagesRef = storageRef.child(Manager.messageText)
        
        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = "UserProfile.jpg"
        let spaceRef = imagesRef.child(fileName)
        
        // File path is "images/space.jpg"
        let path = spaceRef.fullPath
        
        // File name is "space.jpg"
        let name = spaceRef.name
        
        
        
        // Reference to an image file in Firebase Storage
        let reference = FIRStorage.storage().reference(forURL: "gs://github-zebra.appspot.com/\(Manager.messageText)/UserProfile.jpg")
        
        reference.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                //print(error)
                
                print("CAN'T DO IT")
            } else {
                print("DID IT")
                let myImage: UIImage! = UIImage(data: data!)
                //self.DetailedContact_ProfilePicture.image = myImage
                self.Contact_Info_Tab_Picture.image = myImage
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.OpenBusinessCard(_:)))
        
        Contact_Info_Tab.addGestureRecognizer(tap)
        
    }
    
    func OpenBusinessCard(_ gestureRecognizer: UITapGestureRecognizer){
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessCardPopUpID") as! BasicContactViewController
        
        self.addChildViewController(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    /* Reserved for possible later usage part 2/2 (with Callout) //////
     
     //Decides what happens when a Callout is tapped
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
     if let annotation = view.annotation as? PinAnnotation {
     mapView.removeAnnotation(annotation)
     
     
     
     
     
     let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessCardPopUpID") as! BasicContactViewController
     
     
     
     
     
     self.addChildViewController(popOverVC)
     
     popOverVC.view.frame = self.view.frame
     self.view.addSubview(popOverVC.view)
     popOverVC.didMove(toParentViewController: self)
     
     
     
     
     
     /*
     myMap.removeAnnotation(annotation)
     let annotation2 = MKPointAnnotation()
     annotation2.coordinate = CLLocationCoordinate2D(latitude: 25.035368, longitude: 121.562615)
     myMap.removeAnnotation(annotation2)
     
     self.myMap.addAnnotation(annotation2)
     */
     
     /*
     let pinAnnotation = PinAnnotation()
     pinAnnotation.setCoordinate(newCoordinate: annotation.coordinate)
     
     myMap.addAnnotation(pinAnnotation)
     */
     
     
     
     
     
     
     }
     }
     ////////// */
    
    var myCurrentLatitude = CLLocationDegrees()
    var myCurrentLongitude = CLLocationDegrees()
    var mapShouldBeCentered = false
    var spanCount = 0 //To initially set the zoom level when map is first loaded
    
    //Decides what to do when location has been updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Getting the most recent location (from the end of the array)
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        myCurrentLongitude = lastLocation.coordinate.longitude
        myCurrentLatitude = lastLocation.coordinate.latitude
        
        keepUploadingMyLocation()
        
        if mapShouldBeCentered == true || spanCount == 0 {
            
            spanCount = 1
            
            //設定預設地圖大小
            let span = MKCoordinateSpanMake(0.005, 0.005)
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: myCurrentLatitude, longitude: myCurrentLongitude), span: span)
            myMap.setRegion(region, animated: true)
            
            
            //var timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MapViewController.keepUploadingMyLocation), userInfo: nil, repeats: true)
            
            
            
        }
        
        
    }
    
    
    func keepUploadingMyLocation(){
        
        //拿 UID
        if let user = FIRAuth.auth()?.currentUser {
            
            uid = user.uid  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            // No user is signed in.
        }
        //
        //Start updating my latitude to Firebase
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Current-Location/Latitude")
        
        ref.setValue(myCurrentLatitude, withCompletionBlock:
            {(Error, FIRDatabaseReference) -> Void in
                
                if Error != nil {
                    print("CAN'T UPLOAD, Error: \(Error)")
                }
                
        })
        
        
        //Start updating my longitude to Firebase
        ref = FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Current-Location/Longitude")
        
        ref.setValue(myCurrentLongitude, withCompletionBlock:
            {(Error, FIRDatabaseReference) -> Void in
                
                if Error != nil {
                    print("CAN'T UPLOAD, Error: \(Error)")
                }
                
        })
        
    }
    
    
    // Points to the UID of the current user account being proccessed (while we loop through everyone)
    var statusAccount = ""
    
    // Saves every annotation we pinned (so we can erase them all with every friend-fetching-refresh)
    var annotations_Array = [MKAnnotation]()
    
    
    func keepFetchingFriendsLocation(){
        
        
        self.myMap.removeAnnotations(annotations_Array)
        
        annotations_Array.removeAll()
        
        //Iterate through every user in Firebase Database to see which friend is online, and if so, pin that person using annotation
        FIRDatabase.database().reference().child("Online-Status").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for child in snapshots {
                    
                    //Stores users' online status
                    let status = child.value as! String
                    
                    //Stores users' UID
                    self.statusAccount = child.key
                    
                    //If the user is online, and it is not 'me'
                    if (status == "ON" && (self.statusAccount != self.uid)){
                        
                        var lat: CLLocationDegrees?
                        
                        var longi: CLLocationDegrees?
                        
                        var annotation = MKPointAnnotation()
                        
                        var pinAnnotation = PinAnnotation()
                        
                        //Store the UID currently being process because of Firebase reading delay
                        let local_statusAccount = self.statusAccount
                        
                        //Retrieve users' latitude and longitude from Firebase database
                        self.ref = FIRDatabase.database().reference(withPath: "ID/\(self.statusAccount)/Profile/Current-Location/Latitude")
                        
                        self.ref.observe(.value, with: { snapshot in (lat = snapshot.value as? Double,
                                                                     
                            
                            self.ref = FIRDatabase.database().reference(withPath: "ID/\(local_statusAccount)/Profile/Current-Location/Longitude"),
                            
                            self.ref.observe(.value, with: { snapshot in (longi = snapshot.value as? Double,
                                                                          
                                                    //Drop the pin using annotation
                                                                          annotation = MKPointAnnotation(),
                                                                          annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: longi!),
                                                                        
                                                                          pinAnnotation = PinAnnotation(),
                                                                          pinAnnotation.setCoordinate(newCoordinate: annotation.coordinate),
                                                                          pinAnnotation.updateProfileInto(currentNeighbor: local_statusAccount),
                                                                          
                                                                          
                                                                          self.myMap.addAnnotation(pinAnnotation),
                                                                          
                                                                          self.annotations_Array.append(pinAnnotation)
                                
                                
                                
                                )
                            })
                            
                            
                            
                            )
                        })
                        
                        
                    }
                }
            }
            
        })
        
        myMap.delegate = self
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        Contact_Info_Tab_Name.isHidden = true
        Contact_Info_Tab_Job.isHidden = true
        
        //拿 UID
        if let user = FIRAuth.auth()?.currentUser {
            
            uid = user.uid  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
        } else {
            // No user is signed in.
        }
        
        
        // Start processing user's location
        locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        //Start fetching friends' location periodically (without ever stopping)
        var timer2 = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MapViewController.keepFetchingFriendsLocation), userInfo: nil, repeats: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


class PinAnnotation : NSObject, MKAnnotation {
    
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    
    //Initialization for Firebase database
    var ref: FIRDatabaseReference!
    
    var title: String? = "A"
    var subtitle: String? = "B"
    var annotation_Unique_UID: String? = "C"
    
    
    func updateProfileInto(currentNeighbor: String){
        
        //Retrieve data from Firebase database
        ref = FIRDatabase.database().reference(withPath: "ID/\(currentNeighbor)/Profile/Real-Name")
        ref.observe(.value, with: { snapshot in (self.title = snapshot.value as? String)
        })
        
        ref = FIRDatabase.database().reference(withPath: "ID/\(currentNeighbor)/Profile/Job-Description")
        ref.observe(.value, with: { snapshot in (self.subtitle = snapshot.value as? String,
                                                 
                                                 self.annotation_Unique_UID = currentNeighbor,
                                                 
                                                 
                                                 self.subtitle = self.subtitle! + "," + "\(self.annotation_Unique_UID!)"
            
            )
        })

        

    }
    
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        
        self.coord = newCoordinate
        
    }
    
}
