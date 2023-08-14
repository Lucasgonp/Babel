//public enum InjectorFactory {
//    public static func make(
//        resolvingFailureHandler: @escaping FailureHandler = { message in preconditionFailure(message) }
//    ) -> DependencyInjecting {
//        DependencyInjector(failureHandler: resolvingFailureHandler)
//    }
//}
//
//final class DependencyInjector: DependencyInjecting {
//    func register<Dependency>(_ factory: @escaping DependencyFactory, for metaType: Dependency.Type) {
//        <#code#>
//    }
//    
//    func resolve<Dependency>(_ metaType: Dependency.Type) -> Dependency {
//        <#code#>
//    }
//    
//    func safelyResolve<Dependency>(_ metaType: Dependency.Type) -> Dependency? {
//        <#code#>
//    }
//}
