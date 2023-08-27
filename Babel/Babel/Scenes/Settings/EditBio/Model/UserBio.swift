import Foundation

enum UserBio: CaseIterable {
    private typealias Localizable = Strings.UserBio
    
    case wellcome
    case available
    case busy
    case atSchool
    case atTheMovies
    case atWork
    case batteryAboutToDie
    case cantTalk
    case inAMetting
    case atTheGym
    case sleeping
    case urgentCallsOnly
    case custom(String)
    
    var rawValue: String {
        switch self {
        case .wellcome:
            return Localizable.Options.wellcome
        case .available:
            return Localizable.Options.available
        case .busy:
            return Localizable.Options.busy
        case .atSchool:
            return Localizable.Options.atSchool
        case .atTheMovies:
            return Localizable.Options.atTheMovies
        case .atWork:
            return Localizable.Options.atWork
        case .batteryAboutToDie:
            return Localizable.Options.batteryAboutToDie
        case .cantTalk:
            return Localizable.Options.cantTalk
        case .inAMetting:
            return Localizable.Options.inAMetting
        case .atTheGym:
            return Localizable.Options.atTheGym
        case .sleeping:
            return Localizable.Options.sleeping
        case .urgentCallsOnly:
            return Localizable.Options.urgentCallsOnly
        case let .custom(text):
            return text
        }
    }
    
    static var allCases: [UserBio] {
        return [
            UserBio.wellcome,
            UserBio.available,
            UserBio.busy,
            UserBio.atSchool,
            UserBio.atTheMovies,
            UserBio.atWork,
            UserBio.batteryAboutToDie,
            UserBio.cantTalk,
            UserBio.inAMetting,
            UserBio.atTheGym,
            UserBio.sleeping,
            UserBio.urgentCallsOnly
        ]
    }
}
