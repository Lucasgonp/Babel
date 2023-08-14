import Foundation
import UIKit

public extension Color {
    // MARK: - Color Base Primary

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#FADBD8`.
    /// - Dark Mode: `#FADBD8`.
    static let primary050 = Color(#colorLiteral(red: 0.9803921569, green: 0.8588235294, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.8588235294, blue: 0.8470588235, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#EC7063`.
    /// - Dark Mode: `#EC7063`.
    static let primary200 = Color(#colorLiteral(red: 0.9481405616, green: 0.5254969597, blue: 0.4623692036, alpha: 1), #colorLiteral(red: 0.9481405616, green: 0.5254969597, blue: 0.4623692036, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#E74C3C`.
    /// - Dark Mode: `#E74C3C`.
    static let primary500 = Color(#colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#CB4335`.
    /// - Dark Mode: `#CB4335`.
    static let primary800 = Color(#colorLiteral(red: 0.7960784314, green: 0.262745098, blue: 0.2078431373, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.262745098, blue: 0.2078431373, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#943126`.
    /// - Dark Mode: `#943126`.
    static let primary900 = Color(#colorLiteral(red: 0.5803921569, green: 0.1921568627, blue: 0.1490196078, alpha: 1), #colorLiteral(red: 0.5803921569, green: 0.1921568627, blue: 0.1490196078, alpha: 1))

    // MARK: - Color Base Secondary

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#D5D8DC`.
    /// - Dark Mode: `#D5D8DC`.
    static let secondary050 = Color(#colorLiteral(red: 0.8352941176, green: 0.8470588235, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0.8470588235, blue: 0.862745098, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#808B96`.
    /// - Dark Mode: `#808B96`.
    static let secondary200 = Color(#colorLiteral(red: 0.5019607843, green: 0.5450980392, blue: 0.5882352941, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.5450980392, blue: 0.5882352941, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#2C3E50`.
    /// - Dark Mode: `#2C3E50`.
    static let secondary500 = Color(#colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#212F3D`.
    /// - Dark Mode: `#212F3D`.
    static let secondary800 = Color(#colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2392156863, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2392156863, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#17202A`.
    /// - Dark Mode: `#17202A`.
    static let secondary900 = Color(#colorLiteral(red: 0.09019607843, green: 0.1254901961, blue: 0.1647058824, alpha: 1), #colorLiteral(red: 0.09019607843, green: 0.1254901961, blue: 0.1647058824, alpha: 1))
    
    // MARK: - Others

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#FFFFFF`.
    /// - Dark Mode: `#FFFFFF`.
    static let white = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#000000`.
    /// - Dark Mode: `#000000`.
    static let black = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#EAECEE`.
    /// - Dark Mode: `#EAECEE`.
    static let background = Color(#colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9333333333, alpha: 1), #colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9333333333, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#E1FAF0`.
    /// - Dark Mode: `#E1FAF0`.
    static let success050 = Color(#colorLiteral(red: 0.8823529412, green: 0.9803921569, blue: 0.9411764706, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.9803921569, blue: 0.9411764706, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#238662`.
    /// - Dark Mode: `#238662`.
    static let success500 = Color(#colorLiteral(red: 0.137254902, green: 0.5254901961, blue: 0.3843137255, alpha: 1), #colorLiteral(red: 0.137254902, green: 0.5254901961, blue: 0.3843137255, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#01C201`.
    /// - Dark Mode: `#01C201`.
    static let successFull = Color(#colorLiteral(red: 0.003921568627, green: 0.7607843137, blue: 0.003921568627, alpha: 1), #colorLiteral(red: 0.003921568627, green: 0.7607843137, blue: 0.003921568627, alpha: 1))

    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#FFE9E9`.
    /// - Dark Mode: `#FFE9E9`.
    static let warning050 = Color(#colorLiteral(red: 1, green: 0.9137254902, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 1, green: 0.9137254902, blue: 0.9137254902, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#E62320`.
    /// - Dark Mode: `#E62320`.
    static let warning500 = Color(#colorLiteral(red: 0.9019607843, green: 0.137254902, blue: 0.1254901961, alpha: 1), #colorLiteral(red: 0.9019607843, green: 0.137254902, blue: 0.1254901961, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#E62320`.
    /// - Dark Mode: `#E62320`.
    static let lightGrey = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `transparent`.
    /// - Dark Mode: `transparent`.
    static let clear = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), opacity: .zero)
    
    /// Returns a color object whose values are:
    ///
    /// - Light Mode: `#E62320`.
    /// - Dark Mode: `#E62320`.
    static let backgroundLogo = Color(#colorLiteral(red: 0.9843137255, green: 0.9803921569, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.9843137255, green: 0.9803921569, blue: 0.9843137255, alpha: 1))
}

public extension Color {
    /// Grayscale950, default value light color `#060B0D` and dark color `#FFFFFF`
    static let grayscale950 = Color(lightColor: #colorLiteral(red: 0.02352941176, green: 0.0431372549, blue: 0.05098039216, alpha: 1), darkColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    /// Grayscale900, default value light color `#0E161A` and dark color `#FFFFFF`
    static let grayscale900 = Color(lightColor: #colorLiteral(red: 0.05490196078, green: 0.0862745098, blue: 0.1019607843, alpha: 1), darkColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

    /// Grayscale850, default value light color `#172126` and dark color `#F2F2F2`
    static let grayscale850 = Color(lightColor: #colorLiteral(red: 0.09019607843, green: 0.1294117647, blue: 0.1490196078, alpha: 1), darkColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1))

    /// Grayscale800, default value light color `#212D33` and dark color `#F2F2F2`
    static let grayscale800 = Color(lightColor: #colorLiteral(red: 0.1294117647, green: 0.1764705882, blue: 0.2, alpha: 1), darkColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1))

    /// Grayscale750, default value light color `#2D3A40` and dark color `#E5E5E5`
    static let grayscale750 = Color(lightColor: #colorLiteral(red: 0.1764705882, green: 0.2274509804, blue: 0.2509803922, alpha: 1), darkColor: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1))

    /// Grayscale700, default value light color `#39464D` and dark color `#E5E5E5`
    static let grayscale700 = Color(lightColor: #colorLiteral(red: 0.2235294118, green: 0.2745098039, blue: 0.3019607843, alpha: 1), darkColor: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1))

    /// Grayscale600, default value light color `#525F66` and dark color `#CCCCCC`
    static let grayscale600 = Color(lightColor: #colorLiteral(red: 0.3215686275, green: 0.3725490196, blue: 0.4, alpha: 1), darkColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))

    /// Grayscale500, default value light color `#6C7980` and dark color `#AAB0B2`
    static let grayscale500 = Color(lightColor: #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.5019607843, alpha: 1), darkColor: #colorLiteral(red: 0.6666666667, green: 0.6901960784, blue: 0.6980392157, alpha: 1))

    /// Grayscale400, default value light color `#8A9499` and dark color `#8A9499`
    static let grayscale400 = Color(lightColor: #colorLiteral(red: 0.5411764706, green: 0.5803921569, blue: 0.6, alpha: 1), darkColor: #colorLiteral(red: 0.5411764706, green: 0.5803921569, blue: 0.6, alpha: 1))

    /// Grayscale300, default value light color `#AAB0B2` and dark color `#6C7980`
    static let grayscale300 = Color(lightColor: #colorLiteral(red: 0.6666666667, green: 0.6901960784, blue: 0.6980392157, alpha: 1), darkColor: #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.5019607843, alpha: 1))

    /// Grayscale200, default value light color `#CCCCCC` and dark color `#525F66`
    static let grayscale200 = Color(lightColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), darkColor: #colorLiteral(red: 0.3215686275, green: 0.3725490196, blue: 0.4, alpha: 1))

    /// Grayscale100, default value light color `#E5E5E5` and dark color `#39464D`
    static let grayscale100 = Color(lightColor: #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1), darkColor: #colorLiteral(red: 0.2235294118, green: 0.2745098039, blue: 0.3019607843, alpha: 1))

    /// Grayscale050, default value light color `#F2F2F2` and dark color `#39464D`
    static let grayscale050 = Color(lightColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), darkColor: #colorLiteral(red: 0.2235294118, green: 0.2745098039, blue: 0.3019607843, alpha: 1))
}
