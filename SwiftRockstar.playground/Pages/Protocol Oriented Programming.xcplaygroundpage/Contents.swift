//: [Back to error handling](@previous)

//: # Protocol oriented programming
import Foundation
import UIKit
import MapKit
import XCPlayground

let viewController = MyMapViewController()
XCPlaygroundPage.currentPage.liveView = viewController.mapView
viewController.loadView()

/*:
In this demo we will create a map displaying various points of interest with custom images. We start by defining a protocol for our points of interest.
*/
protocol PointOfInterest {
    var name : String { get }
    var coordinate : CLLocationCoordinate2D { get }
    var displayImage : UIImage { get }
    func getAnnotation() -> CustomMapAnnotation
}

/*:
Lets create a struct representing hotels by implementing the PointOfInterest protocol. I choose to create a struct rather than a class since a struct is a value type rather than a refrence type. This means that even if multiple references are done to the Hotel there will be no issues if one of the refrences changes something about the hotel.
*/

struct Hotel: PointOfInterest {
    var name : String
    var coordinate : CLLocationCoordinate2D
    var displayImage : UIImage {
        get{
            return UIImage(imageLiteral: "hotels")
        }
    }
    func getAnnotation() -> CustomMapAnnotation {
        return  CustomMapAnnotation(coordinate: coordinate, image: displayImage)
    }
}

extension Hotel: Equatable {}
func ==(lhs: Hotel, rhs: Hotel) -> Bool{
    return lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
}

/*:
We also want our map to be able to display annotations for restaturants. Let's create a struct for restaurants as well.
*/
struct Restaurant: PointOfInterest {
    var name : String
    var coordinate : CLLocationCoordinate2D
    var displayImage : UIImage {
        get{
            return UIImage(imageLiteral: "restaurants")
        }
    }
    func getAnnotation() -> CustomMapAnnotation {
        return  CustomMapAnnotation(coordinate: coordinate, image: displayImage)
    }
}

extension Restaurant: Equatable {}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool{
    return lhs.name == rhs.name && lhs.coordinate == rhs.coordinate
}
/*:
At this point we can see that the implementation for getAnnotation() is identical for both restaurant and hotel. In obejct oriented programming we would have created an abstract super class in order to not need to duplicate the code. However that would mean that we would have to implement hotel and restaurant as classes. Leading to that they become refrence types. Swift provides us with a better and more flexible solution; protocol extensions. We can create an extension for the PointOfInterest protocol.
*/

extension PointOfInterest {
    func getAnnotation() -> CustomMapAnnotation{
        return  CustomMapAnnotation(coordinate: coordinate, image: displayImage)
    }
}

/*:
Lets try adding our annotations to our map.
*/


let lundCenterCoordinate = CLLocationCoordinate2D(latitude: 55.706742,longitude:  13.187464)

let hotel = Hotel(name: "Grand Hotel", coordinate: lundCenterCoordinate)

let restaurant = Restaurant(name: "Restaurant", coordinate:  CLLocationCoordinate2D(latitude: 55.704741,longitude:  13.187464))
let pointsOfInterest: [PointOfInterest] = [restaurant, hotel]

for poi in pointsOfInterest{
    viewController.mapView.addAnnotation(poi.getAnnotation())
}

/*:
Now that we are warmed up with protocol extensions lets dig a little deeper. Say we want to compare our different types of PointsOfInterest. We can add a method isEqualtTo to the Point of interest protocol. We can then instead of implementing it on each type implement it in a conditional extension.
*/


extension PointOfInterest where Self: Equatable  {
    func isEqualTo(other: PointOfInterest) -> Bool {
        guard let o = other as? Self else { return false }
        return self == o
    }


}

hotel.isEqualTo(restaurant)
hotel.isEqualTo(hotel)

