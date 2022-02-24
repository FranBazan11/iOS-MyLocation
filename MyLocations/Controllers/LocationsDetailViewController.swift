//
//  LocationsDetailViewController.swift
//  MyLocations
//
//  Created by Lagash Systems on 20/03/2020.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
class LocationsDetailViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    var managedObjectContext:NSManagedObjectContext!
    var image: UIImage?
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    var observer:  Any!
    
    var date = Date()
    var locationToEdit: Location?{
        didSet{
            if let location = locationToEdit{
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(
                    location.latitude, location.longitude)
                placemark = location.placemark
                title = "Edit Location"
            }
        }
    }
    var descriptionText = ""
    @IBOutlet weak var descriptionTextView:UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    var categoryName = "No Category"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = locationToEdit {
            title = "Edit Location"
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    show(image: theImage)
                }
            }
        }
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark{
            addressLabel.text = string(from:placemark)
        }else{
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date:date)
        // Hide Keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        listenForBackgroundNotification()
    }
    // Con esto escuchamos la notificacion UIApplication.didEnterBackgroundNotification y validamos si tenemos presentada la camara o la galeria y cerramos ese controlador y el teclado si esa activo
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main){ [weak self] _ in
            if let weakSelf = self {
                if weakSelf.presentedViewController != nil {
                    weakSelf.dismiss(animated: false, completion: nil)
                }
                weakSelf.descriptionTextView.resignFirstResponder()
            }
        }
    }
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer!)
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        
        imageHeight.constant = 260
        tableView.reloadData()
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
        
    }
    func format(date: Date) -> String{
        
        return dateFormatter.string(from: date)
        
    }
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placemark.thoroughfare {
            line1 += s
        }
        var line2 = ""
        if let s = placemark.locality {
            line2 += s + " "
        }
        if let s = placemark.administrativeArea {
            line2 += s + " "
        }
        if let s = placemark.postalCode {
            line2 += s
        }
        return line1 + "\n" + line2
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCatergoryName = categoryName
        }
    }
    
    //MARK:- Actions
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue){
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCatergoryName
        categoryLabel.text = categoryName
    }
    
    @IBAction func done(){
        
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else{
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        //Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch  {
                    print("Error writing file: \(error)")
                }
            }
        }
        
                do {
            try managedObjectContext.save()
            // Creamos archivo Functions y creamos la closure afterDelay
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch  {
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }
    //MARK:- Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 || indexPath.section == 1{
            return indexPath
        } else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        cell.selectedBackgroundView = selection
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            pickPhoto()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    
    extension LocationsDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        //MARK:- Image Helper Methods
        
        func pickPhoto() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                showPhotoMenu()
            } else {
                choosePhotoFromLibrery()
            }
        }
        
        func showPhotoMenu() {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(actCancel)
            
            let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler:
            { _ in
                self.takePhotoWithCamera()
            })
            
            alert.addAction(actPhoto)
            
            let actLibrary = UIAlertAction(title: "Choose From Librery", style: .default, handler:
            { _ in
                self.choosePhotoFromLibrery()
            })
            
            alert.addAction(actLibrary)
            present(alert, animated: true, completion: nil)
        }
        
        func takePhotoWithCamera() {
            let imagePicker = MyImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.view.tintColor = view.tintColor
            present(imagePicker, animated: true, completion: nil)
        }
        
        func choosePhotoFromLibrery() {
            let imagePicker = MyImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.view.tintColor = view.tintColor
            present(imagePicker, animated: true, completion: nil)
        }
        
        //MARK:- Image Picket Delegates
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
            if let theImage = image {
                show(image: theImage)
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}
