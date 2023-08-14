public typealias DependencyFactory = () -> AnyObject
public typealias DependencyFactoryResolver = (DependencyResolving) -> AnyObject

public protocol DependencyResolving {
    func resolve<Dependency>(_ metaType: Dependency.Type) -> Dependency
    func safelyResolve<Dependency>(_ metaType: Dependency.Type) -> Dependency?
}

public extension DependencyResolving {
    func resolve<Dependency>() -> Dependency {
        resolve(Dependency.self)
    }
}

public protocol DependencyRegistering {
    func register<Dependency>(_ factory: @escaping DependencyFactory, for metaType: Dependency.Type)
}

public protocol DependencyInjecting: DependencyRegistering, DependencyResolving {}

public extension DependencyInjecting {
    func register<Dependency>(_ factory: @escaping DependencyFactoryResolver, for metaType: Dependency.Type) {
        let factory: DependencyFactory = { factory(self) }
        register(factory, for: metaType)
    }
}
