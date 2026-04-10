import SwiftUI

struct ActivityOption: Identifiable {
    let id: String
    let label: String
    let emoji: String
}

let activityOptions: [ActivityOption] = [
    ActivityOption(id: "marry",    label: "嫁娶 — 婚禮、結婚",     emoji: "💍"),
    ActivityOption(id: "business", label: "開市開業 — 創業、開店",  emoji: "🏪"),
    ActivityOption(id: "move",     label: "搬家入宅 — 喬遷新居",    emoji: "🏠"),
    ActivityOption(id: "travel",   label: "出行遠遊 — 旅行出差",    emoji: "✈️"),
    ActivityOption(id: "sign",     label: "簽約合作 — 立券交易",    emoji: "📝"),
    ActivityOption(id: "construct",label: "動土修造 — 裝修建設",    emoji: "🔨"),
    ActivityOption(id: "pray",     label: "祈福祭祀 — 拜拜祈願",    emoji: "🙏"),
    ActivityOption(id: "medical",  label: "求醫療病 — 手術就醫",    emoji: "🏥"),
    ActivityOption(id: "bed",      label: "安床 — 新床佈置",        emoji: "🛏"),
    ActivityOption(id: "burial",   label: "安葬 — 喪葬事宜",       emoji: "⚱️"),
]

struct AuspiciousDateResult: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
    let stars: String
    let jz: JianZhuInfo
    let gz: GanZhi
}

struct AuspiciousDateView: View {
    @State private var selectedActivity = "marry"
    @State private var daysRange = 30
    @State private var results: [AuspiciousDateResult] = []
    @State private var isSearching = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                formCard
                if isSearching {
                    HStack { Spacer(); ProgressView().tint(Theme.gold); Spacer() }.padding(30)
                } else if results.isEmpty {
                    emptyState
                } else {
                    ForEach(results) { r in ResultRow(result: r) }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Theme.bgDeep.ignoresSafeArea())
    }

    // MARK: - Form

    private var formCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeaderView(title: "擇吉日功能")

                VStack(alignment: .leading, spacing: 6) {
                    Text("選擇用事類型").font(.system(size: 13)).foregroundColor(Theme.textSub)
                    Menu {
                        ForEach(activityOptions) { opt in
                            Button(opt.emoji + " " + opt.label) { selectedActivity = opt.id }
                        }
                    } label: {
                        HStack {
                            let cur = activityOptions.first { $0.id == selectedActivity }
                            Text((cur?.emoji ?? "") + " " + (cur?.label ?? ""))
                                .font(.system(size: 15)).foregroundColor(Theme.textMain)
                            Spacer()
                            Image(systemName: "chevron.down").foregroundColor(Theme.gold)
                        }
                        .padding(12)
                        .background(Theme.bgCard2)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                        .cornerRadius(8)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("查詢天數").font(.system(size: 13)).foregroundColor(Theme.textSub)
                    HStack(spacing: 8) {
                        ForEach([30, 60, 90], id: \.self) { d in
                            Button("近\(d)天") {
                                daysRange = d
                            }
                            .font(.system(size: 14))
                            .foregroundColor(daysRange == d ? Theme.bgDark : Theme.gold)
                            .padding(.vertical, 8).frame(maxWidth: .infinity)
                            .background(daysRange == d ? Theme.gold : Theme.bgCard2)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.4), lineWidth: 1))
                            .cornerRadius(8)
                        }
                    }
                }

                Button {
                    searchDates()
                } label: {
                    Text("開始擇日查詢")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .tracking(2)
                        .foregroundColor(Theme.bgDeep)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: [Theme.goldDim, Theme.gold],
                                                   startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(8)
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("☀️").font(.system(size: 40))
            Text("選擇用事類型後點擊查詢").font(.system(size: 14)).foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    // MARK: - Search Logic

    private func searchDates() {
        isSearching = true
        results = []
        DispatchQueue.global(qos: .userInitiated).async {
            let cal = Calendar(identifier: .gregorian)
            var found: [AuspiciousDateResult] = []
            let start = Date()
            for i in 0..<daysRange {
                guard let date = cal.date(byAdding: .day, value: i, to: start) else { continue }
                let score = scoreDay(date, activity: selectedActivity)
                if score >= 50 {
                    let jz = getJianzhu(date)
                    let dg = dayGZ(date)
                    found.append(AuspiciousDateResult(date: date, score: score,
                                                      stars: starsFromScore(score), jz: jz, gz: dg))
                }
            }
            found.sort { $0.score > $1.score }
            DispatchQueue.main.async {
                results = found
                isSearching = false
            }
        }
    }
}

struct ResultRow: View {
    let result: AuspiciousDateResult
    private let cal = Calendar(identifier: .gregorian)

    var scoreColor: Color {
        switch result.score {
        case 80...: return Theme.gold
        case 65...: return Theme.green
        default:    return Theme.textSub
        }
    }

    var body: some View {
        let ld = gregToLunar(result.date)
        let c = cal.dateComponents([.year,.month,.day], from: result.date)
        let weekdays = ["日","一","二","三","四","五","六"]
        let wd = weekdays[cal.component(.weekday, from: result.date) - 1]
        let prefix = ld.isLeap ? "閏" : ""

        return CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text("\(c.year!)年\(c.month!)月\(c.day!)日")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.textMain)
                            Text("星期\(wd)").font(.system(size: 13)).foregroundColor(Theme.textSub)
                        }
                        Text("農曆 \(prefix)\(CCC.lunarMonths[ld.month-1])\(CCC.lunarDays[ld.day-1])")
                            .font(.system(size: 13)).foregroundColor(Theme.textSub)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(result.stars).font(.system(size: 13)).foregroundColor(scoreColor)
                        Text("\(result.score)分").font(.system(size: 12)).foregroundColor(scoreColor)
                    }
                }
                HStack(spacing: 6) {
                    Text(result.gz.gz)
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundColor(Theme.goldLight)
                    JianZhuBadge(idx: result.jz.idx, name: result.jz.name)
                }
                HStack(spacing: 0) {
                    Text("宜：").font(.system(size: 12)).foregroundColor(Theme.green)
                    Text(result.jz.yi.prefix(4).joined(separator: " · "))
                        .font(.system(size: 12)).foregroundColor(Theme.textSub)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(result.score >= 80 ? Theme.gold.opacity(0.4) : result.score >= 65 ? Theme.green.opacity(0.25) : Color.clear, lineWidth: 1)
        )
    }
}
