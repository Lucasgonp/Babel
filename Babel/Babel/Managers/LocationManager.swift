import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private(set) var currentLocation: CLLocationCoordinate2D?
    
    private var authorizationHandler: (() -> Void)?
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    private override init() {
        super.init()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location?.coordinate
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func authorizeLocationAccess(completion: (() -> Void)?) {
        authorizationHandler = completion
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            completion?()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationHandler?()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
