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
            return Localizable.Options.wellcome.localized()
        case .available:
            return Localizable.Options.available.localized()
        case .busy:
            return Localizable.Options.busy.localized()
        case .atSchool:
            return Localizable.Options.atSchool.localized()
        case .atTheMovies:
            return Localizable.Options.atTheMovies.localized()
        case .atWork:
            return Localizable.Options.atWork.localized()
        case .batteryAboutToDie:
            return Localizable.Options.batteryAboutToDie.localized()
        case .cantTalk:
            return Localizable.Options.cantTalk.localized()
        case .inAMetting:
            return Localizable.Options.inAMetting.localized()
        case .atTheGym:
            return Localizable.Options.atTheGym.localized()
        case .sleeping:
            return Localizable.Options.sleeping.localized()
        case .urgentCallsOnly:
            return Localizable.Options.urgentCallsOnly.localized()
        case let .custom(text):
            return text.localized()
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
