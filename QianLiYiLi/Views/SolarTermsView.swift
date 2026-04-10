import SwiftUI

struct SolarTermsView: View {
    @State private var year = Calendar(identifier: .gregorian).component(.year, from: Date())
    private let now = Date()

    private let seasonGroups: [(String, String, [Int])] = [
        ("春", "spring",  [2,3,4,5,6,7]),
        ("夏", "summer",  [8,9,10,11,12,13]),
        ("秋", "autumn",  [14,15,16,17,18,19]),
        ("冬", "winter",  [20,21,22,23,0,1]),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                currentTermCard
                yearPickerRow
                allTermsCard
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Theme.bgDeep.ignoresSafeArea())
    }

    // MARK: - Current Term

    private var currentTermCard: some View {
        let info = getCurrentTerm(now)
        return VStack(spacing: 0) {
            if let cur = info.current {
                VStack(spacing: 8) {
                    Text("當前節氣").font(.system(size: 12)).foregroundColor(Theme.textSub)
                    Text(cur.name)
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundColor(Theme.gold)
                    Text(formatDate(cur.date))
                        .font(.system(size: 13)).foregroundColor(Theme.textSub)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(colors: [Theme.gold.opacity(0.1), Theme.gold.opacity(0.03)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.gold.opacity(0.2), lineWidth: 1))
                .cornerRadius(12)
            }
            if let nxt = info.next {
                HStack {
                    Text("下一個節氣：")
                        .font(.system(size: 13)).foregroundColor(Theme.textSub)
                    Text(nxt.name)
                        .font(.system(size: 13, weight: .bold, design: .serif))
                        .foregroundColor(Theme.goldLight)
                    Spacer()
                    let days = daysUntil(nxt.date)
                    Text(days > 0 ? "還有 \(days) 天" : "今日")
                        .font(.system(size: 13)).foregroundColor(Theme.gold)
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                .background(Theme.bgCard)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Theme.gold.opacity(0.1), lineWidth: 1))
            }
        }
        .cornerRadius(12)
    }

    // MARK: - Year Picker

    private var yearPickerRow: some View {
        HStack(spacing: 12) {
            Button { year -= 1 } label: {
                Image(systemName: "chevron.left").foregroundColor(Theme.gold)
                    .frame(width: 36, height: 36)
                    .background(Theme.bgCard2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                    .cornerRadius(8)
            }
            Text("\(year)年節氣時刻表")
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundColor(Theme.gold)
            Spacer()
            Button { year += 1 } label: {
                Image(systemName: "chevron.right").foregroundColor(Theme.gold)
                    .frame(width: 36, height: 36)
                    .background(Theme.bgCard2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                    .cornerRadius(8)
            }
        }
    }

    // MARK: - All Terms

    private var allTermsCard: some View {
        let terms = getSolarTermsForYear(year)
        let termByIdx = Dictionary(uniqueKeysWithValues: terms.map { ($0.idx, $0) })

        return CardView {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeaderView(title: "全年節氣")

                // Season badges
                HStack(spacing: 8) {
                    ForEach(seasonGroups, id: \.0) { s, cls, _ in
                        Text(s + "季")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(seasonColor(cls))
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(seasonColor(cls).opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(seasonColor(cls).opacity(0.3), lineWidth: 1))
                            .cornerRadius(20)
                    }
                }

                // Term list (by season order)
                let sortedTerms = terms
                ForEach(sortedTerms, id: \.idx) { term in
                    TermRow(term: term, isNow: now >= term.date &&
                            (sortedTerms.first(where: { $0.date > term.date })?.date ?? Date.distantFuture) > now,
                            isPassed: term.date < now, now: now)
                }
            }
        }
    }

    // MARK: - Helpers

    private func formatDate(_ d: Date) -> String {
        let cal = Calendar(identifier: .gregorian)
        let c = cal.dateComponents([.year,.month,.day,.hour,.minute], from: d)
        return String(format: "%d年%02d月%02d日 %02d:%02d", c.year!, c.month!, c.day!, c.hour!, c.minute!)
    }

    private func daysUntil(_ d: Date) -> Int {
        let diff = d.timeIntervalSinceNow
        return max(0, Int(ceil(diff / 86400)))
    }

    private func seasonColor(_ cls: String) -> Color {
        switch cls {
        case "spring": return Color(hex:"#55CC88")
        case "summer": return Color(hex:"#E08844")
        case "autumn": return Theme.gold
        case "winter": return Color(hex:"#88AADD")
        default: return Theme.textSub
        }
    }
}

struct TermRow: View {
    let term: SolarTerm
    let isNow: Bool
    let isPassed: Bool
    let now: Date

    private func formatDate(_ d: Date) -> String {
        let c = Calendar(identifier: .gregorian).dateComponents([.month,.day,.hour,.minute], from: d)
        return String(format: "%02d/%02d %02d:%02d", c.month!, c.day!, c.hour!, c.minute!)
    }
    private var countdown: String {
        if isPassed { return "已過" }
        let days = Int(ceil(term.date.timeIntervalSinceNow / 86400))
        return days > 0 ? "還有\(days)天" : "今日"
    }

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(isNow ? Theme.gold : isPassed ? Theme.textMuted : Theme.goldDim)
                .frame(width: 8, height: 8)
                .shadow(color: isNow ? Theme.gold : .clear, radius: 3)
            Text(term.name)
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundColor(isPassed ? Theme.textSub : Theme.textMain)
                .frame(width: 40, alignment: .leading)
            Text(formatDate(term.date))
                .font(.system(size: 13))
                .foregroundColor(Theme.textSub)
            Spacer()
            Text(countdown)
                .font(.system(size: 12))
                .foregroundColor(isNow ? Theme.gold : isPassed ? Theme.textMuted : Theme.gold.opacity(0.7))
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(isNow ? Theme.gold.opacity(0.08) : Theme.bgCard2)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(isNow ? Theme.gold : isPassed ? Color.clear : Theme.gold.opacity(0.15), lineWidth: 1))
        .cornerRadius(8)
        .opacity(isPassed ? 0.55 : 1)
    }
}
