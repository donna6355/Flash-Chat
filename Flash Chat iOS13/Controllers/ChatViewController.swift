//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "a@b.com", body: "Morning!"),
        Message(sender: "1@2.com", body: "What up")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.delegate = self
        tableView.dataSource = self
        title =  K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
        
    }
    
    func loadMessage(){
        //read data only one time : .getDocument
        //keep listening data : .addSnapshotListenr
        db.collection(K.FStore.collectionName).addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e = error {
                print("there was an issue retreiving data from firestore, \(e)")
            }else {
                if let snapshotDocs = querySnapshot?.documents{
                    for doc in snapshotDocs {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String{
                            self.messages.append(Message(sender: sender, body: body))
                            
                            //recommended convention to usd DispatchQueue when it manipulates ui
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField:messageSender,
                K.FStore.bodyField:messageBody,
            ]) { error in
                if let e = error{
                    print("there was an issue saving data in firestore, \(e)")
                } else{
                    print("successfully saved data")
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController:UITableViewDataSource{ // responsible for populating the table view
    //how many cells in need
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    //which cell to put into the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath ) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
}
// interaction with each cell
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}


// CLASS HEIRARCHY
// is : type checking // if VAR is TYPE {}
// as! : forced downcast // let msgCell = cell as! MsgCell -> precisely indicate the subclass
// as? : // if let msgCell = cell as? MsgCell -> safer way tha forced downcast
// as : upcast //covert sub class to super class type

//Any > AnyObject > NSObject
//Any : all objects
//AnyObject : created from Class ** int,double,... created from struct
//NSObject : foundation object
