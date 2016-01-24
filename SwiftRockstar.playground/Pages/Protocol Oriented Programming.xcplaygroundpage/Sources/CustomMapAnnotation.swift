import Foundation
import MapKit

public class CustomMapAnnotation :NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var image: UIImage
    
    public init(coordinate: CLLocationCoordinate2D, image: UIImage){
        self.coordinate = coordinate
        self.image = image
    }
    
    public func annotationView() -> MKPinAnnotationView {
        return MKPinAnnotationView(annotation: self, reuseIdentifier: "annotation")
    }
}