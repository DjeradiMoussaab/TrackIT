import UIKit
import MapKit


struct Location {
    var long : CLLocationDegrees
    var lat  : CLLocationDegrees
    var name : String
}


class MapViewController: UIViewController,MKMapViewDelegate {
    
    var locationJSON : AirportLocation?
    var locationsJSON = Array<AirportLocation>()
    var locationNames: [String] = ["ALG","CDG","HEL"]
    var i = 0
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 9000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if #available(iOS 11.0, *) {
            mapView?.register(ArtWorkView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        getAirportLocation(airportName: locationNames[0])

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func getAirportLocation(airportName : String) {
        API.APIInstance.GetLocation(airportName: airportName, onSuccess: { data in
                let decoder = JSONDecoder()
                self.locationJSON = try? decoder.decode(AirportLocation.self, from: data)
                DispatchQueue.main.async {
                    self.locationsJSON.append(self.locationJSON!)
                    self.i = self.i + 1
                    if ( self.i != self.locationNames.count ) {
                        self.getAirportLocation(airportName : self.locationNames[self.i])
                    } else {
                        self.drawMap()
                    }
                }
            }, onFailure: { error in
                print(error)
                
            })
    }
    
    
    
    func drawMap() {
        var coords : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for i in 0...locationsJSON.count-1 {
            coords.append(CLLocationCoordinate2D(latitude: locationsJSON[i].latitude , longitude: locationsJSON[i].longitude) )
            mapView?.addAnnotation(Artwork(
                title: "Airport",
                locationName: locationsJSON[i].name,
                discipline: "maps",
                coordinate: CLLocationCoordinate2D(latitude: locationsJSON[i].latitude, longitude: locationsJSON[i].longitude)))
        }
        let startLocation = CLLocation(latitude: coords[1].latitude, longitude: coords[1].longitude)
        centerMapOnLocation(location: startLocation)
        mapView.addOverlay(MKPolyline(coordinates: coords, count: coords.count))
        mapView.centerCoordinate = coords[1]
        mapView.region = MKCoordinateRegion(center: coords[1], span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .red
            testlineRenderer.lineWidth = 3.0
            testlineRenderer.lineDashPattern = [5, 5]
            return testlineRenderer
        }
        fatalError("Something wrong...")
        //return MKOverlayRenderer()
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}


