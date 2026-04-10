import SwiftUI

enum Theme {
    static let bgDeep   = Color(hex: "#090C13")
    static let bgDark   = Color(hex: "#0F1520")
    static let bgCard   = Color(hex: "#141B2D")
    static let bgCard2  = Color(hex: "#1A2238")
    static let gold     = Color(hex: "#C9A84C")
    static let goldLight = Color(hex: "#E8C97A")
    static let goldDim  = Color(hex: "#7A6228")
    static let textMain = Color(hex: "#F0ECE0")
    static let textSub  = Color(hex: "#8A8A9A")
    static let textMuted = Color(hex: "#555570")
    static let red      = Color(hex: "#E05555")
    static let green    = Color(hex: "#55B87A")
    static let blue     = Color(hex: "#5588E0")
    static let purple   = Color(hex: "#9055E0")

    static func wuxingColor(_ wx: String) -> Color {
        switch wx {
        case "木": return green
        case "火": return Color(hex: "#E07755")
        case "土": return gold
        case "金": return Color(hex: "#88CCDD")
        case "水": return blue
        default:   return textSub
        }
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        self.init(
            red:   Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8)  & 0xFF) / 255,
            blue:  Double( rgb        & 0xFF) / 255
        )
    }
}

// MARK: - Reusable Components

struct CardView<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(16)
            .background(Theme.bgCard)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.gold.opacity(0.15), lineWidth: 1))
            .cornerRadius(12)
    }
}

struct SectionHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Rectangle()
                .fill(Theme.gold)
                .frame(width: 3, height: 14)
                .cornerRadius(2)
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundColor(Theme.gold)
                .tracking(2)
            Spacer()
        }
    }
}

struct InfoRowView: View {
    let label: String
    let value: String
    var valueColor: Color = Theme.textMain
    var body: some View {
        HStack {
            Text(label).foregroundColor(Theme.textSub).font(.system(size: 15))
            Spacer()
            Text(value).foregroundColor(valueColor).font(.system(size: 15, weight: .medium))
        }
        .padding(.vertical, 8)
    }
}

struct GoldDivider: View {
    var body: some View {
        Divider().background(Theme.gold.opacity(0.15))
    }
}
