import SwiftUI

struct TodayView: View {
    @State private var now = Date()          // 實際當前時間（供時辰高亮用）
    @State private var viewDate = Date()     // 目前查看的日期
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var isViewingToday: Bool {
        Calendar.current.isDateInToday(viewDate)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                dateHeroSection
                fourPillarsCard
                yijiCard
                dayInfoCard
                pengzuCard
                shichenCard
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Theme.bgDeep.ignoresSafeArea())
        .onReceive(timer) { t in
            now = t
            if isViewingToday { viewDate = t }
        }
    }

    // MARK: - Date Hero

    private var dateHeroSection: some View {
        let ld  = gregToLunar(viewDate)
        let cal = Calendar(identifier: .gregorian)
        let yg  = yearGZ(ld.year)
        let mg  = monthGZ(viewDate)
        let dg  = dayGZ(viewDate)
        let weekdays = ["日","一","二","三","四","五","六"]
        let wd  = weekdays[cal.component(.weekday, from: viewDate) - 1]
        let moon = moonPhaseText(moonPhaseAt(dateToJDE(viewDate)))
        let term = getCurrentTerm(viewDate).current

        return VStack(spacing: 8) {
            // 上一日 / 回今日 / 下一日
            HStack(spacing: 16) {
                Button(action: { changeDay(-1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.gold)
                        .frame(width: 36, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                }
                if !isViewingToday {
                    Button(action: { viewDate = Calendar.current.startOfDay(for: Date()) }) {
                        Text("回今日")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.gold)
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.goldDim, lineWidth: 1))
                    }
                } else {
                    Spacer().frame(width: 60)
                }
                Button(action: { changeDay(1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.gold)
                        .frame(width: 36, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.3), lineWidth: 1))
                }
            }
            .padding(.top, 8)

            Text("\(cal.component(.year, from: viewDate))年\(cal.component(.month, from: viewDate))月\(cal.component(.day, from: viewDate))日 星期\(wd)")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSub)

            Text("\(yg.gz)年 \(mg.gz)月 \(dg.gz)日")
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundColor(Theme.goldLight)

            let prefix = ld.isLeap ? "閏" : ""
            Text("農曆 \(prefix)\(CCC.lunarMonths[ld.month - 1])\(CCC.lunarDays[ld.day - 1])  \(CCC.zodiac[yg.branch])年")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSub)

            HStack(spacing: 8) {
                Text("\(moon.icon) \(moon.name)")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSub)
                if let t = term {
                    Text(t.name + "期間")
                        .font(.system(size: 12))
                        .padding(.horizontal, 10).padding(.vertical, 3)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.goldDim, lineWidth: 1))
                        .foregroundColor(Theme.gold)
                }
            }
        }
    }

    private func changeDay(_ offset: Int) {
        viewDate = Calendar.current.date(byAdding: .day, value: offset, to: viewDate) ?? viewDate
    }

    // MARK: - Four Pillars

    private var fourPillarsCard: some View {
        let ld = gregToLunar(viewDate)
        let yg = yearGZ(ld.year)
        let mg = monthGZ(viewDate)
        let dg = dayGZ(viewDate)
        let hg = hourGZ(date: now, dayStem: dg.stem)
        let pillars: [(String, GanZhi, String)] = [
            ("年柱", yg, CCC.zodiac[yg.branch]),
            ("月柱", mg, CCC.branch[mg.branch]),
            ("日柱", dg, CCC.zodiac[dg.branch]),
            ("時柱", hg, CCC.branch[hg.branch] + "時"),
        ]
        return CardView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "四柱八字")
                HStack(spacing: 8) {
                    ForEach(pillars, id: \.0) { label, gz, sub in
                        PillarCell(label: label, gz: gz, sub: sub)
                    }
                }
            }
        }
    }

    // MARK: - 宜忌

    private var yijiCard: some View {
        let jz = getJianzhu(viewDate)
        return CardView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "今日宜忌")
                HStack(spacing: 8) {
                    JianZhuBadge(idx: jz.idx, name: jz.name)
                    Text(jz.desc)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSub)
                }
                HStack(alignment: .top, spacing: 10) {
                    YiJiColumn(title: "今日宜", items: jz.yi, isAuspicious: true)
                    YiJiColumn(title: "今日忌", items: jz.ji, isAuspicious: false)
                }
            }
        }
    }

    // MARK: - Day Info

    private var dayInfoCard: some View {
        let dg = dayGZ(viewDate)
        let jz = getJianzhu(viewDate)
        let chong = getChong(viewDate)
        let suisha = getSuisha(viewDate)
        return CardView {
            VStack(alignment: .leading, spacing: 0) {
                SectionHeaderView(title: "日神資訊")
                    .padding(.bottom, 4)
                GoldDivider()
                InfoRowView(label: "日沖", value: "沖\(chong)", valueColor: Theme.red)
                GoldDivider()
                InfoRowView(label: "煞方", value: suisha, valueColor: Theme.red)
                GoldDivider()
                InfoRowView(label: "財神方位", value: CCC.caIshenDir[dg.stem], valueColor: Theme.green)
                GoldDivider()
                InfoRowView(label: "喜神方位", value: CCC.xIshenDir[dg.stem], valueColor: Theme.green)
                GoldDivider()
                InfoRowView(label: "納音五行", value: getNayinForToday(), valueColor: Theme.gold)
                GoldDivider()
                InfoRowView(label: "建除十二神", value: jz.name + "日", valueColor: jzColor(jz.luck))
            }
        }
    }

    private func getNayinForToday() -> String {
        let dg = dayGZ(viewDate)
        return CCC.nayinNames[dg.idx / 2]
    }

    private func jzColor(_ luck: Int) -> Color {
        switch luck {
        case 3:  return Theme.gold
        case 2:  return Theme.green
        case 1:  return Theme.textSub
        default: return Theme.red
        }
    }

    // MARK: - 彭祖

    private var pengzuCard: some View {
        let pz = getPengzu(viewDate)
        return CardView {
            VStack(alignment: .leading, spacing: 10) {
                SectionHeaderView(title: "彭祖百忌")
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("干忌：").font(.system(size: 13)).foregroundColor(Theme.gold).bold()
                        Text(pz.stem).font(.system(size: 13)).foregroundColor(Theme.textSub)
                    }
                    HStack(alignment: .top, spacing: 4) {
                        Text("支忌：").font(.system(size: 13)).foregroundColor(Theme.gold).bold()
                        Text(pz.branch).font(.system(size: 13)).foregroundColor(Theme.textSub)
                    }
                }
                .padding(12)
                .background(Theme.gold.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.goldDim.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4])))
                .cornerRadius(8)
            }
        }
    }

    // MARK: - 時辰

    private var shichenCard: some View {
        let dg = dayGZ(viewDate)
        let cal = Calendar(identifier: .gregorian)
        // 時辰高亮：查看今日用當前時間，查看其他日不高亮
        let h = isViewingToday ? cal.component(.hour, from: now) : -1
        let curBranch = h < 1 ? 0 : ((h + 1) / 2) % 12
        return CardView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeaderView(title: "今日時辰吉凶")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(0..<12, id: \.self) { i in
                        let startStem = (dg.stem % 5) * 2
                        let sIdx = (startStem + i) % 10
                        let gz = CCC.stems[sIdx] + CCC.branch[i]
                        let fortune = getShichenFortune(date: viewDate, hourBranch: i)
                        let t = CCC.shichenHours[i]
                        let isCur = isViewingToday && i == curBranch
                        ShichenCell(gz: gz, timeRange: "\(String(format: "%02d", t.0 % 24))~\(String(format: "%02d", t.1 % 24))時",
                                    fortune: fortune, isCurrent: isCur)
                    }
                }
            }
        }
    }
}

// MARK: - Sub-components

struct PillarCell: View {
    let label: String
    let gz: GanZhi
    let sub: String
    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 11)).foregroundColor(Theme.textMuted)
            VStack(spacing: 0) {
                Text(CCC.stems[gz.stem])
                    .font(.system(size: 22, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.wuxingColor(CCC.wuxingS[gz.stem]))
                Text(CCC.branch[gz.branch])
                    .font(.system(size: 22, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.wuxingColor(CCC.wuxingB[gz.branch]))
            }
            Text("\(CCC.wuxingS[gz.stem])/\(CCC.wuxingB[gz.branch])")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSub)
            Text(sub).font(.system(size: 10)).foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Theme.bgCard2)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gold.opacity(0.2), lineWidth: 1))
        .cornerRadius(8)
    }
}

struct JianZhuBadge: View {
    let idx: Int
    let name: String
    var badgeColor: Color {
        switch idx {
        case 0, 5: return Theme.gold
        case 1, 9, 10: return Theme.green
        case 2, 3, 4: return Theme.blue
        case 6: return Theme.red
        case 7, 11: return Theme.textSub
        case 8: return Theme.purple
        default: return Theme.textSub
        }
    }
    var body: some View {
        Text(name + "日")
            .font(.system(size: 14, weight: .bold, design: .serif))
            .foregroundColor(badgeColor)
            .padding(.horizontal, 12).padding(.vertical, 3)
            .background(badgeColor.opacity(0.12))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(badgeColor.opacity(0.4), lineWidth: 1))
            .cornerRadius(10)
    }
}

struct YiJiColumn: View {
    let title: String
    let items: [String]
    let isAuspicious: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isAuspicious ? Theme.green : Theme.red)
            ForEach(items, id: \.self) { item in
                HStack(spacing: 6) {
                    Image(systemName: isAuspicious ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(isAuspicious ? Theme.green : Theme.red)
                    Text(item).font(.system(size: 13)).foregroundColor(Theme.textSub)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Theme.bgCard2)
        .cornerRadius(8)
    }
}

struct ShichenCell: View {
    let gz: String
    let timeRange: String
    let fortune: ShichenFortune
    let isCurrent: Bool
    var fortuneColor: Color {
        switch fortune {
        case .excellent: return Theme.green
        case .good:      return Theme.gold
        case .neutral:   return Theme.textSub
        case .bad:       return Theme.red
        }
    }
    var body: some View {
        HStack(spacing: 8) {
            Text(gz)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .foregroundColor(Theme.textMain)
                .frame(width: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text(timeRange).font(.system(size: 11)).foregroundColor(Theme.textMuted)
                Text(fortune.rawValue).font(.system(size: 13, weight: .semibold)).foregroundColor(fortuneColor)
            }
            Spacer()
        }
        .padding(8)
        .background(isCurrent ? Theme.gold.opacity(0.1) : Theme.bgCard2)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(isCurrent ? Theme.gold : Theme.gold.opacity(0.12), lineWidth: 1))
        .cornerRadius(8)
    }
}
