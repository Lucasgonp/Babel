import DesignKit
import MapKit

final class MapViewController: UIViewController {
    typealias Localizable = Strings
    
    private let location: CLLocation
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.addAnnotation(MapAnnotation(title: nil, coordinate: location.coordinate))
        return mapView
    }()
    
    init(location: CLLocation) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        centerMap()
        userLocation()
    }
}

extension MapViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.fillWithSubview(subview: mapView, navigationSafeArea: true)
    }
    
    func setupConstraints() { }
    
    func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        title = Localizable.MapView.title
    }
}

private extension MapViewController {
    func centerMap() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func userLocation() {
        LocationManager.shared.authorizeLocationAccess { [weak self] in
            self?.mapView.showsUserLocation = true
        }
    }
}
