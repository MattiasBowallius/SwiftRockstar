import Foundation
import MapKit

public class MyMapViewController : UIViewController{
    
    public let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
    
    let lundCenterCoordinate = CLLocationCoordinate2D(latitude: 55.706742,longitude:  13.187464)
    let mapZoom = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    override public func loadView() {
        super.loadView()
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: lundCenterCoordinate, span: mapZoom), animated: false)
        mapView.setNeedsDisplay()
    }
}


extension MyMapViewController : MKMapViewDelegate{
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if let customAnnotation = annotation as? CustomMapAnnotation {
            mapView.translatesAutoresizingMaskIntoConstraints = false
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as MKAnnotationView!
            
            if (annotationView == nil) {
                annotationView = customAnnotation.annotationView()
            } else {
                annotationView.annotation = annotation;
            }
            
            annotationView.image = customAnnotation.image
            return annotationView
        } else {
            return nil
        }
    }

}