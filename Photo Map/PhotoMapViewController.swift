//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate,LocationsViewControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var latitude: NSNumber = 0.0
    var longitude:  NSNumber = 0.0
    var imageSelected : UIImage!
    var imageTapped : UIImage!
    let vc = UIImagePickerController()
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vc.delegate = self
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
            MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        //uncomment the line below to shoe the image
      mapView.delegate = self
        
     
    }

    @IBAction func onCamera(_ sender: AnyObject) {
        
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false{
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
//            vc.dismissViewControllerAnimated(true, completion: nil)
        }
            
        else {
        
            vc.sourceType = UIImagePickerControllerSourceType.camera
            self.present(vc, animated: true, completion: nil)
//            vc.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageSelected = image
        //print(self.imageSelected)
        picker.dismiss(animated: true, completion:  go )
    
    }
    
    func go(){
        self.performSegue(withIdentifier: "tagSegue",
            sender: self)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            
            let detailsButton = UIButton(type: UIButtonType.detailDisclosure)
            annotationView!.rightCalloutAccessoryView = detailsButton
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            annotationView!.image = thumbnail
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = self.imageSelected
        
        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        
        UIGraphicsEndImageContext()
       
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.imageTapped = (view.leftCalloutAccessoryView as! UIImageView).image
        performSegue(withIdentifier: "fullImageSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let vc = segue.destination as! LocationsViewController
            vc.delegate = self
        }
        else  {
            if let fullImageVC = segue.destination as? FullImageViewController {
                fullImageVC.image = self.imageTapped
            }
            
        }
    }
    func locationsPickedLocation(_ controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        print(latitude)
        print(longitude)
        
        self.latitude = latitude
        self.longitude = longitude
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
        annotation.coordinate = coordinate
        annotation.title = "Picture!"
        self.mapView.addAnnotation(annotation)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
