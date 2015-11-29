//
//  Order.swift
//  TabBarTrial
//
//  Created by orkenstein on 28.11.15.
//  Copyright © 2015 orkenstein. All rights reserved.
//

import UIKit
import Mantle
import MapKit
import Alamofire

class Order: MTLModel, MTLJSONSerializing {
  
  var uuid: String = ""
  var departureAddress: Address?
  var destinationAddress: Address?

  class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return NSDictionary.mtl_identityPropertyMapWithModel(self)
  }
  
  class func departureAddressJSONTransformer() -> NSValueTransformer {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Address)
  }
  
  class func destinationAddressJSONTransformer() -> NSValueTransformer {
    return MTLJSONAdapter.dictionaryTransformerWithModelClass(Address)
  }
  
  class func orders(success: (([Order]?) -> Void)) {
    Alamofire.request(.GET, "http://mobapply.com/tests/orders/").responseJSON { (response) -> Void in
      guard let successArray = response.result.value as? [AnyObject] else {
        return
      }
      var ordersArray: [Order]?
      do {
        ordersArray = try MTLJSONAdapter.modelsOfClass(Order.self, fromJSONArray: successArray) as? [Order]
      } catch {
        //  Do something
        return
      }
      
      success(ordersArray!)
    }
  }
  
}

class Address: MTLModel, MTLJSONSerializing {
  
  var city: String = ""
  var country: String = ""
  var countryCode: String = ""
  var houseNumber: String = ""
  var street: String = ""
  var zipCode: String = ""
  
  class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return NSDictionary.mtl_identityPropertyMapWithModel(self)
  }
  
  func annotation(success: ((Annotation) -> Void)) {
    let addressString = country + "+" + city + "+" + zipCode + "+" + street + "+" + houseNumber
    Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: ["address" : addressString, "key" : "AIzaSyD_tf2oF4GKmzNiGk-JOe3wNRts5JK0uFU"],
      encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
        guard let JSON = response.result.value as? [String : AnyObject] else {
          return
        }
        guard let successArray = JSON["results"] as? [AnyObject] else {
          return
        }
        var resultsArray: [Annotation]?
        do {
          resultsArray = try MTLJSONAdapter.modelsOfClass(Annotation.self, fromJSONArray: successArray) as? [Annotation]
        } catch {
          //  Do something
          return
        }

        guard let annotation = resultsArray?.first else {
          return
        }
        
        success(annotation)
    }
  }
}

class Annotation: MTLModel, MTLJSONSerializing, MKAnnotation {
  var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var departure: Bool = true
  
  class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
    return ["coordinate" : "geometry.location"]
  }
  
  class func coordinateJSONTransformer() -> NSValueTransformer {
    return MTLValueTransformer(usingForwardBlock: { (object, success, errir) -> AnyObject! in
      let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
      guard let dict = object as? [String: Double] else {
        return NSValue(MKCoordinate: coordinate)
      }
      guard let lat = dict["lat"], let lng = dict["lng"] else {
        return NSValue(MKCoordinate: coordinate)
      }
      return NSValue(MKCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
    })
  }
}



