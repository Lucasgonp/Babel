import DesignKit
import MapKit

final class MapViewController: UIViewController {
    typealias Localizable = Strings
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.addAnnotation(MapAnnotation(title: userName, coordinate: location.coordinate))
        return mapView
    }()
    
    private let location: CLLocation
    private let userName: String?
    
    init(location: CLLocation, userName: String? = nil) {
        self.location = location
        self.userName = userName
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
        
        view.backgroundColor = Color.backgroundSecondary.uiColor
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
