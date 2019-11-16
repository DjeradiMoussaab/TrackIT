

import Foundation
import MapKit

class ArtWorkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: -20)
            image = UIImage(named: "circle")
            
        }
    }
}
