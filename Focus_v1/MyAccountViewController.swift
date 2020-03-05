//
//  SecondViewController.swift
//  Focus_v1
//
//  Created by Adrian Iannantuono on 2020-02-14.
//  Copyright © 2020 adrianiannantuono. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBannerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.backgroundColor = UIColor(named: "TextFieldColor")
        // Do any additional setup after loading the view.
    }

    @IBAction func changeUserImage(_ sender: Any) {
        showImagePickerController(sender)
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
            userImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}


