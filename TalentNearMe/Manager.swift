//
//  Manager.swift
//  TalentNearMe
//
//  Created by Daphne Jiang on 01/11/2016.
//  Copyright © 2016 M.A.D. Crew. All rights reserved.
//


//manager.swift

import Foundation
import FirebaseDatabase

    struct Manager {

        static var messageText = String()
        static var UID_of_Friend = String()
        static var autoChatRoomName = String()
        static var chatRoomRealName = String()
        static var ref = FIRDatabaseReference()
  

    }


    struct MessageFields {
        static let name = "name"
        static let text = "text"
    
    }
