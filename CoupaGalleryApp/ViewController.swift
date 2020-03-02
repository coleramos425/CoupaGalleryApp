//
//  ViewController.swift
//  CoupaGalleryApp
//
//  Created by TJ Hendrickson on 2/28/20.
//  Copyright © 2020 Cole Ramos. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class ViewController: UIViewController {

// MARK: - Properties
    //These outlets connect collectionView structure and the search query to the code
    @IBOutlet var textField: UITextField!
    @IBOutlet var collectionView: UICollectionView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    private var testImages: [UIImage] = [   //Can use these to test without connecting to API
        UIImage(named: "b1.jpg")!,
        UIImage(named: "b2.jpg")!,
        UIImage(named: "b3.jpg")!
    ]
    private let sectionSpacing = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    private var selectedPhotos = [UnsplashPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }

// MARK: - Sign-in to API
    //This authentication process is how to you connect to your Unsplash dev credentials
    @IBAction func presentUnsplashPhotoPicker(sender: AnyObject?) {
        let allowsMultipleSelection = true  //API gives developer choice to search multiple or a single image
        let configuration = UnsplashPhotoPickerConfiguration(
            accessKey: "zCxOsYDOY7xjZLklmA1CJM7mdzwAvoLy9sn0AQQa7ic",
            secretKey: "7GZt8egN33Mr_jQVpIi8RQFsi9p-BkRtu1hgQ0HkkdU",
            query: textField.text,
            allowsMultipleSelection: allowsMultipleSelection
        )   //Note: If no text is entered, API returns popular image list. Also, if search query returns no results then user is notified to try again
        
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
        unsplashPhotoPicker.photoPickerDelegate = self

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }
    
    @IBAction func startScrolling(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.grey
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
}

// MARK: - Send results to table
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)

        if let photoCell = cell as? DataCollectionViewCell {
            let photo = selectedPhotos[indexPath.row]
            photoCell.downloadPhoto(photo)
        }
        
        activityIndicator.stopAnimating()
        return cell
    }
}

//MARK: - Onscreen formatting of photos returned from API
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionSpacing.left
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth

        return CGSize(width: widthPerItem, height: widthPerItem)
   
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionSpacing.left
    }
}

// MARK: - Tests/Verification
extension ViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos selectedPhotos: [UnsplashPhoto]) {
        print("Photo picker did select \(selectedPhotos.count) photos")

        self.selectedPhotos = selectedPhotos

        collectionView.reloadData()
    }
    //If for some reason the connection to unspash API was not successful, return error
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Photo picker canceled")
    }
}

//Verifying user input
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
