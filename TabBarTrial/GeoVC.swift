//
//  GeoVC.swift
//  TabBarTrial
//
//  Created by orkenstein on 28.11.15.
//  Copyright © 2015 orkenstein. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import Mantle

let kGreenReuse = "Green"
let kRedReuse = "Red"

class GeoVC: CustomVC, MKMapViewDelegate {
  
  let mapView = MKMapView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    view.addSubview(mapView)
    getData()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    mapView.frame = view.bounds
    mapView.delegate = self
  }
  
  func getData () {
    Order.orders {[weak self] (ordersArray) -> Void in
      for order in ordersArray! {
        order.departureAddress?.annotation({ (annotation) -> Void in
          guard let weakSelf = self else {
            return
          }
          annotation.departure = true //  Better incapsulate
          weakSelf.mapView.addAnnotation(annotation)
        })
        
        order.destinationAddress?.annotation({ (annotation) -> Void in
          guard let weakSelf = self else {
            return
          }
          annotation.departure = false //  Better incapsulate
          weakSelf.mapView.addAnnotation(annotation)
        })
      }
    }
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    guard let customAnnotation = annotation as? Annotation else {
      return MKPinAnnotationView(annotation: annotation, reuseIdentifier: kRedReuse)
    }
    var view = mapView.dequeueReusableAnnotationViewWithIdentifier(customAnnotation.departure ? kGreenReuse : kRedReuse) as? MKPinAnnotationView
    if view != nil {
      return view
    }
    
    view = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: nil)
    view!.pinColor = customAnnotation.departure ? .Green : .Red
    
    return view
  }
}
