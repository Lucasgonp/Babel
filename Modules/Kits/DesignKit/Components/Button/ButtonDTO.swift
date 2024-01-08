public struct ButtonDTO {
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let font: FontSystemStyle
    let minimumHeight: CGFloat?
    
    struct Size {
        let minimumHeight: CGFloat
    }
}
