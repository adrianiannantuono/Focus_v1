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
    @IBOutlet weak var bannerImage: UIImageView!
    var chosenImage: UIImageView!
    
    var gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        gradient.frame = bannerImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.25)
        bannerImage.layer.insertSublayer(gradient, at: 0)
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
        dismiss(animated: true, completion: nil)
    }
}


