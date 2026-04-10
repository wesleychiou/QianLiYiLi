import SwiftUI

struct MonthCalendarView: View {
    @State private var calYear  = Calendar(identifier: .gregorian).component(.year,  from: Date())
    @State private var calMonth = Calendar(identifier: .gregorian).component(.month, from: Date()) - 1
    @State private var selected: Date? = nil

    private let cal = Calendar(identifier: .gregorian)
    private let dowLabels = ["日","一","二","三","四","五","六"]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                headerRow
                dowRow
                calGrid
                if let sel = selected { detailPanel(sel) }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Theme.bgDeep.ignoresSafeArea())
    }

    // MARK: - Header

    private var headerRow: some View {
        HStack {
            Button { prevMonth() } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Theme.gold)
                    .frame(width: 36, height: 36)
                    .background(Theme.bgCard2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                    .cornerRadius(8)
            }
            Spacer()
            Text("\(calYear)年\(calMonth + 1)月")
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(Theme.gold)
            Spacer()
            Button { nextMonth() } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.gold)
                    .frame(width: 36, height: 36)
                    .background(Theme.bgCard2)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                    .cornerRadius(8)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Day-of-week labels

    private var dowRow: some View {
        HStack(spacing: 2) {
            ForEach(dowLabels.indices, id: \.self) { i in
                Text(dowLabels[i])
                    .font(.system(size: 12))
                    .foregroundColor(i == 0 ? Color(hex:"#E06666") : i == 6 ? Color(hex:"#6688CC") : Theme.textMuted)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Calendar Grid

    private var calGrid: some View {
        let firstDay = firstWeekday()
        let daysInMonth = daysInCurrentMonth()
        let today = Date()
        let todayComps = cal.dateComponents([.year,.month,.day], from: today)
        let terms = getSolarTermsForYear(calYear)
        var termMap: [String: String] = [:]
        for t in terms {
            let c = cal.dateComponents([.year,.month,.day], from: t.date)
            if let y = c.year, let m = c.month, let d = c.day {
                termMap["\(y)-\(m)-\(d)"] = t.name
            }
        }

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
            // Leading blanks
            ForEach(0..<firstDay, id: \.self) { _ in
                Rectangle().fill(Color.clear).frame(minHeight: 62)
            }
            // Days
            ForEach(1...daysInMonth, id: \.self) { d in
                let date = cal.date(from: DateComponents(year: calYear, month: calMonth + 1, day: d))!
                let dc = cal.dateComponents([.year,.month,.day], from: date)
                let isToday = dc.year == todayComps.year && dc.month == todayComps.month && dc.day == todayComps.day
                let isSel = selected.map { cal.isDate($0, inSameDayAs: date) } ?? false
                let dow = cal.component(.weekday, from: date) - 1
                let ld = gregToLunar(date)
                let termKey = "\(calYear)-\(calMonth + 1)-\(d)"
                let termName = termMap[termKey] ?? ""
                let jz = getJianzhu(date)
                let moonP = moonPhaseAt(dateToJDE(date))
                let moonIcon: String = moonP < 0.04 || moonP > 0.96 ? "🌑" : moonP > 0.46 && moonP < 0.54 ? "🌕" : ""
                CalDayCell(
                    day: d, lunarLabel: ld.day == 1 ? CCC.lunarMonths[ld.month - 1] : CCC.lunarDays[ld.day - 1],
                    termName: termName, moonIcon: moonIcon, jzLuck: jz.luck,
                    isToday: isToday, isSelected: isSel, isSunday: dow == 0, isSaturday: dow == 6
                )
                .onTapGesture {
                    selected = isSel ? nil : date
                }
            }
        }
        .background(Theme.bgCard)
        .cornerRadius(12)
    }

    // MARK: - Detail Panel

    private func detailPanel(_ date: Date) -> some View {
        let ld  = gregToLunar(date)
        let yg  = yearGZ(ld.year)
        let mg  = monthGZ(date)
        let dg  = dayGZ(date)
        let jz  = getJianzhu(date)
        let pz  = getPengzu(date)
        let moon = moonPhaseText(moonPhaseAt(dateToJDE(date)))
        let cal2 = Calendar(identifier: .gregorian)
        let c = cal2.dateComponents([.year,.month,.day], from: date)
        let weekdays = ["日","一","二","三","四","五","六"]
        let wd = weekdays[cal2.component(.weekday, from: date) - 1]
        let prefix = ld.isLeap ? "閏" : ""
        return CardView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(c.year!)年\(c.month!)月\(c.day!)日 星期\(wd)")
                            .font(.system(size: 13)).foregroundColor(Theme.textSub)
                        Text("農曆 \(prefix)\(CCC.lunarMonths[ld.month-1])\(CCC.lunarDays[ld.day-1])")
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundColor(Theme.goldLight)
                    }
                    Spacer()
                    JianZhuBadge(idx: jz.idx, name: jz.name)
                }
                Text("\(yg.gz)年 \(mg.gz)月 \(dg.gz)日")
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundColor(Theme.gold)
                GoldDivider()
                HStack(alignment: .top, spacing: 10) {
                    YiJiColumn(title: "宜", items: jz.yi, isAuspicious: true)
                    YiJiColumn(title: "忌", items: jz.ji, isAuspicious: false)
                }
                GoldDivider()
                HStack(spacing: 12) {
                    Label(moon.icon + " " + moon.name, systemImage: "")
                        .font(.system(size: 12)).foregroundColor(Theme.textSub)
                    Text("沖\(getChong(date))").font(.system(size: 12)).foregroundColor(Theme.red)
                    Text(getSuisha(date)).font(.system(size: 12)).foregroundColor(Theme.red)
                }
                GoldDivider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("彭祖百忌").font(.system(size: 12)).foregroundColor(Theme.gold)
                    Text("干忌：\(pz.stem)").font(.system(size: 12)).foregroundColor(Theme.textSub)
                    Text("支忌：\(pz.branch)").font(.system(size: 12)).foregroundColor(Theme.textSub)
                }
            }
        }
    }

    // MARK: - Helpers

    private func prevMonth() {
        if calMonth == 0 { calMonth = 11; calYear -= 1 } else { calMonth -= 1 }
        selected = nil
    }
    private func nextMonth() {
        if calMonth == 11 { calMonth = 0; calYear += 1 } else { calMonth += 1 }
        selected = nil
    }
    private func firstWeekday() -> Int {
        let comps = DateComponents(year: calYear, month: calMonth + 1, day: 1)
        let first = cal.date(from: comps)!
        return cal.component(.weekday, from: first) - 1
    }
    private func daysInCurrentMonth() -> Int {
        let comps = DateComponents(year: calYear, month: calMonth + 1)
        return cal.range(of: .day, in: .month, for: cal.date(from: comps)!)!.count
    }
}

// MARK: - Day Cell

struct CalDayCell: View {
    let day: Int
    let lunarLabel: String
    let termName: String
    let moonIcon: String
    let jzLuck: Int
    let isToday: Bool
    let isSelected: Bool
    let isSunday: Bool
    let isSaturday: Bool

    private var dotColor: Color {
        switch jzLuck {
        case 3, 2: return Theme.green
        case 0:    return Theme.red
        default:   return Theme.goldDim
        }
    }
    private var dayColor: Color {
        isSunday ? Color(hex:"#E08888") : isSaturday ? Color(hex:"#8899DD") : Theme.textMain
    }

    var body: some View {
        VStack(spacing: 1) {
            Text("\(day)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(dayColor)
            if !termName.isEmpty {
                Text(termName).font(.system(size: 9, weight: .bold)).foregroundColor(Theme.gold)
            }
            Text(lunarLabel).font(.system(size: 10)).foregroundColor(Theme.textSub).lineLimit(1).minimumScaleFactor(0.7)
            if !moonIcon.isEmpty { Text(moonIcon).font(.system(size: 11)) }
            Circle().fill(dotColor).frame(width: 5, height: 5)
        }
        .frame(maxWidth: .infinity, minHeight: 62)
        .background(isSelected ? Theme.gold.opacity(0.15) : Theme.bgCard2)
        .overlay(RoundedRectangle(cornerRadius: 6)
            .stroke(isToday ? Theme.gold : isSelected ? Theme.gold.opacity(0.6) : Color.clear, lineWidth: isToday ? 1.5 : 1))
        .cornerRadius(6)
    }
}
