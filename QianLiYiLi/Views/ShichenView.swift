import SwiftUI

struct ShichenView: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                shichenCard
                explanationCard
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Theme.bgDeep.ignoresSafeArea())
        .onReceive(timer) { _ in now = Date() }
    }

    // MARK: - Main Card

    private var shichenCard: some View {
        let dg = dayGZ(now)
        let cal = Calendar(identifier: .gregorian)
        let h = cal.component(.hour, from: now)
        let curBranch = h < 1 ? 0 : ((h + 1) / 2) % 12

        return CardView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "今日十二時辰")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(0..<12, id: \.self) { i in
                        let startStem = (dg.stem % 5) * 2
                        let sIdx = (startStem + i) % 10
                        let gz = CCC.stems[sIdx] + CCC.branch[i]
                        let fortune = getShichenFortune(date: now, hourBranch: i)
                        let t = CCC.shichenHours[i]
                        let isCur = i == curBranch
                        ShichenDetailCell(
                            index: i, gz: gz,
                            timeRange: "\(String(format:"%02d", t.0 % 24)):00 – \(String(format:"%02d", t.1 % 24)):00",
                            fortune: fortune, isCurrent: isCur
                        )
                    }
                }
            }
        }
    }

    // MARK: - Explanation Card

    private var explanationCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "五虎遁時法說明")
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        methodRow("甲己日", "子時起甲子")
                        methodRow("乙庚日", "子時起丙子")
                        methodRow("丙辛日", "子時起戊子")
                        methodRow("丁壬日", "子時起庚子")
                        methodRow("戊癸日", "子時起壬子")
                    }
                }
                GoldDivider()
                SectionHeaderView(title: "五鼠遁年起月法")
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        methodRow("甲己年", "正月起丙寅")
                        methodRow("乙庚年", "正月起戊寅")
                        methodRow("丙辛年", "正月起庚寅")
                        methodRow("丁壬年", "正月起壬寅")
                        methodRow("戊癸年", "正月起甲寅")
                    }
                }
            }
        }
    }

    private func methodRow(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key)
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(Theme.gold)
                .frame(width: 60, alignment: .leading)
            Text("：")
                .foregroundColor(Theme.textMuted)
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSub)
            Spacer()
        }
    }
}

struct ShichenDetailCell: View {
    let index: Int
    let gz: String
    let timeRange: String
    let fortune: ShichenFortune
    let isCurrent: Bool

    private var fortuneColor: Color {
        switch fortune {
        case .excellent: return Theme.green
        case .good:      return Theme.gold
        case .neutral:   return Theme.textSub
        case .bad:       return Theme.red
        }
    }
    private var fortuneLabel: String {
        switch fortune {
        case .excellent: return "黃道吉時"
        case .good:      return "次吉時辰"
        case .neutral:   return "平常時辰"
        case .bad:       return "黑道凶時"
        }
    }
    private var fortuneBg: Color {
        isCurrent ? Theme.gold.opacity(0.08) : Theme.bgCard2
    }

    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 2) {
                Text(gz)
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(isCurrent ? Theme.goldLight : Theme.textMain)
                Text(CCC.branch[index] + "時")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text(timeRange)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)
                Text(fortuneLabel)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(fortuneColor)
                if isCurrent {
                    Text("▶ 當前時辰")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.gold)
                }
            }
            Spacer()
        }
        .padding(10)
        .background(fortuneBg)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(isCurrent ? Theme.gold : Theme.gold.opacity(0.12), lineWidth: isCurrent ? 1.5 : 1))
        .cornerRadius(8)
    }
}
