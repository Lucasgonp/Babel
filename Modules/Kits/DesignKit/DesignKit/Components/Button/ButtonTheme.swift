public enum ButtonTheme {
    case primary(title: String, titleColor: Color = .white, minimumHeight: CGFloat = 42)
    case secondary(title: String, titleColor: Color = .primary500, minimumHeight: CGFloat = 42)
    case tertiary(title: String, titleColor: Color = .grayscale400)
    case custom(dto: ButtonDTO)
    
    var dto: ButtonDTO {
        switch self {
        case let .primary(title, titleColor, minimumHeight):
            return ButtonDTO(
                title: title,
                titleColor: titleColor,
                backgroundColor: .primary500,
                cornerRadius: 10,
                font: Font.md,
                minimumHeight: minimumHeight
            )
        case let .secondary(title, titleColor, minimumHeight):
            return ButtonDTO(
                title: title,
                titleColor: titleColor,
                backgroundColor: .clear,
                cornerRadius: 10,
                font: Font.md,
                minimumHeight: minimumHeight
            )
        case let .tertiary(title, titleColor):
            return ButtonDTO(
                title: title,
                titleColor: titleColor,
                backgroundColor: .clear,
                cornerRadius: 10,
                font: Font.md,
                minimumHeight: nil
            )
        case .custom(let dto):
            return dto
        }
    }
}
