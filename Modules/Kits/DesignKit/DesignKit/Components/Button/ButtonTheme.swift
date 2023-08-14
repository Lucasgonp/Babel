public enum ButtonTheme {
    case primary(title: String)
    case secondary(title: String)
    case custom(dto: ButtonDTO)
    
    var dto: ButtonDTO {
        switch self {
        case .primary(let title):
            return ButtonDTO(
                title: title,
                titleColor: .white,
                backgroundColor: .primary800,
                cornerRadius: 10,
                font: Font.md
            )
        case .secondary(let title):
            return ButtonDTO(
                title: title,
                titleColor: .primary800,
                backgroundColor: .clear,
                cornerRadius: 10,
                font: Font.md
            )
        case .custom(let dto):
            return dto
        }
    }
}
