//
//  SecondViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyAccountViewController: UIViewController {
    var databaseRef = Database.database().reference()
    var storageRef: StorageReference!
    var user:User!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    var chosenImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        storageRef = Storage.storage().reference()
        
        view.backgroundColor = UIColor.systemBackground
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        gradient.frame = bannerImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.25)
        bannerImage.layer.insertSublayer(gradient, at: 0)
        
        // Create a reference to the file you want to download
        var imageRef = storageRef.child("Users/" + "\(user.uid)/ProfileImages/UserImage/userImage")
        // Load profile image and banner image
        for i in 1...2 {
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
              } else {
                if (i == 1) {
                    self.userImage.image = UIImage(data: data!)
                } else if (i == 2) {
                    self.bannerImage.image = UIImage(data: data!)
                }
              }
            }
            imageRef = storageRef.child("Users/" + "\(user.uid)/ProfileImages/BannerImage/bannerImage")
        }
        
        databaseRef.child("Users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          self.name.text = "" + (value?["firstname"] as? String ?? "") + " " + (value?["lastname"] as? String ?? "")
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }
    



    @IBAction func changeUserImage(_ sender: Any) {
        chosenImage = userImage;
        showImagePickerController(sender)
    }
    @IBAction func changeBannerImage(_ sender: Any) {
        chosenImage = bannerImage;
        showImagePickerController(sender)
        bannerImage.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension MyAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage.image = originalImage
        }
        // Upload Image to Firebase
        var data = NSData()
        data = chosenImage.image!.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        var filePath = "Users/" + "\(user.uid)/ProfileImages/" // path where you wanted to store img in storage
        if (chosenImage == userImage) {
            filePath = filePath + "UserImage/userImage"
        } else if (chosenImage == bannerImage){
            filePath = filePath + "BannerImage/bannerImage"
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
}


