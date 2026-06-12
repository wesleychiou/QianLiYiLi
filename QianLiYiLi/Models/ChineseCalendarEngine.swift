import Foundation

// MARK: - Constants

enum CCC {
    static let stems   = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
    static let branch  = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
    static let zodiac  = ["鼠","牛","虎","兔","龍","蛇","馬","羊","猴","雞","狗","豬"]
    static let wuxingS = ["木","木","火","火","土","土","金","金","水","水"]
    static let wuxingB = ["水","土","木","木","土","火","火","土","金","金","土","水"]
    static let lunarDays = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
                             "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
                             "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
    static let lunarMonths = ["正月","二月","三月","四月","五月","六月",
                               "七月","八月","九月","十月","十一月","十二月"]
    static let termNames = ["小寒","大寒","立春","雨水","驚蟄","春分","清明","穀雨",
                             "立夏","小滿","芒種","夏至","小暑","大暑","立秋","處暑",
                             "白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至"]
    static let termAngles: [Double] = [285,300,315,330,345,0,15,30,45,60,75,90,
                                        105,120,135,150,165,180,195,210,225,240,255,270]
    static let zhongqiAngles: [Double] = [0,30,60,90,120,150,180,210,240,270,300,330]
    static let jianzhu = ["建","除","滿","平","定","執","破","危","成","收","開","閉"]
    static let jzYi: [[String]] = [
        ["祈福","出行","上任","入學","動土"],
        ["沐浴","搬家","求醫","解除","掃舍"],
        ["嫁娶","入宅","開市","納財"],
        ["開市","出行","修造","祭祀"],
        ["嫁娶","安床","簽約","入宅"],
        ["祭祀","捕捉","收穫"],
        ["求醫"],
        ["祭祀","祈福","解除"],
        ["嫁娶","開業","移徙","祭祀"],
        ["嫁娶","收穫","安葬"],
        ["開市","出行","移徙","祈福"],
        ["安葬","謝土","修墳"],
    ]
    static let jzJi: [[String]] = [
        ["開市","嫁娶","安葬"],
        ["嫁娶","訴訟","入宅"],
        ["動土","安葬","修造"],
        ["種植"],
        ["出行","訴訟","動土"],
        ["開市","出行","嫁娶"],
        ["諸事不宜","嫁娶","動土","開市","出行"],
        ["安床","嫁娶","出行"],
        ["訴訟","官司"],
        ["出行","開市"],
        ["安葬","喪事"],
        ["嫁娶","入宅","出行","開市"],
    ]
    static let jzLuck = [1,2,2,2,2,1,0,1,3,2,3,1]
    static let jzDesc = ["凶日，不宜大事","凶，宜除舊佈新","吉，萬事可為","吉，宜日常事務",
                          "吉，宜婚嫁安床","小吉，宜收穫","大凶，諸事不宜","不宜輕舉妄動",
                          "大吉，萬事如意","吉，宜收穫嫁娶","大吉，宜開展新局","不宜開創新事"]
    static let caIshenDir = ["東北","正北","正東","東南","正南","正南","正東","東南","正北","東北"]
    static let xIshenDir  = ["東南","東南","正南","正南","西南","正北","正北","西北","西北","正西"]
    static let pengzuStem = [
        "甲不開倉，財物耗散","乙不栽植，千株不長","丙不修竈，必見災殃","丁不剃頭，頭主生瘡",
        "戊不受田，田主不祥","己不破券，二比並亡","庚不經絡，機張虛張","辛不合醬，主人不嘗",
        "壬不泱水，更難提防","癸不詞訟，理弱敵強"
    ]
    static let pengzuBranch = [
        "子不問卜，自惹禍殃","丑不冠帶，主不還鄉","寅不祭祀，神鬼不嘗","卯不穿井，水泉不香",
        "辰不哭泣，必主重喪","巳不遠行，財物伏藏","午不苫蓋，屋主更張","未不服藥，毒氣入腸",
        "申不安床，鬼祟入房","酉不會客，醉坐顛狂","戌不吃犬，作怪上床","亥不嫁娶，不利新郎"
    ]
    static let nayinNames = [
        "海中金","爐中火","大林木","路旁土","劍鋒金","山頭火","澗下水","城頭土",
        "白蠟金","楊柳木","泉中水","屋上土","霹靂火","松柏木","長流水","砂中金",
        "山下火","平地木","壁上土","金箔金","覆燈火","天河水","大驛土","釵釧金",
        "桑柘木","大溪水","沙中土","天上火","石榴木","大海水"
    ]
    static let luckyHours: [[Int]] = [
        [0,1,3,7,8,10],[1,2,4,8,9,11],[2,3,5,9,10,0],[3,4,6,10,11,1],
        [4,5,7,11,0,2],[5,6,8,0,1,3],[6,7,9,1,2,4],[7,8,10,2,3,5],
        [8,9,11,3,4,6],[9,10,0,4,5,7],[10,11,1,5,6,8],[11,0,2,6,7,9]
    ]
    static let shichenHours: [(Int,Int)] = [
        (23,1),(1,3),(3,5),(5,7),(7,9),(9,11),(11,13),(13,15),(15,17),(17,19),(19,21),(21,23)
    ]
}

// MARK: - Astronomy

func normDeg(_ a: Double) -> Double { ((a.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360) }

func dateToJDE(_ d: Date) -> Double { d.timeIntervalSince1970 / 86400.0 + 2440587.5 }
func jdeToDate(_ j: Double) -> Date { Date(timeIntervalSince1970: (j - 2440587.5) * 86400.0) }

func gregToJDE(_ y: Int, _ m: Int, _ d: Int) -> Double {
    var yy = y, mm = m
    if mm <= 2 { yy -= 1; mm += 12 }
    let A = yy / 100
    let B = 2 - A + A / 4
    return floor(365.25 * Double(yy + 4716)) + floor(30.6001 * Double(mm + 1)) + Double(d) + Double(B) - 1524.5
}

func solarLon(_ jde: Double) -> Double {
    let T  = (jde - 2451545) / 36525
    let T2 = T * T
    let L  = normDeg(280.46646 + 36000.76983 * T + 0.0003032 * T2)
    let M  = normDeg(357.52911 + 35999.05029 * T - 0.0001537 * T2)
    let Mr = M * .pi / 180
    let C  = (1.914602 - 0.004817 * T - 0.000014 * T2) * sin(Mr)
           + (0.019993 - 0.000101 * T) * sin(2 * Mr) + 0.000289 * sin(3 * Mr)
    let O  = normDeg(125.04 - 1934.136 * T) * .pi / 180
    return normDeg(L + C - 0.00569 - 0.00478 * sin(O))
}

func findTermJDE(approx: Double, target: Double) -> Double {
    var j = approx
    for _ in 0..<60 {
        var d = normDeg(target - solarLon(j))
        if d > 180 { d -= 360 }
        let delta = d * 365.25 / 360
        j += delta
        if abs(delta) < 1e-7 { break }
    }
    return j
}

func termApprox(_ year: Int, _ angle: Double) -> Double {
    let daysFromVE = normDeg(angle - 80) / 360 * 365.25
    return gregToJDE(year, 1, 1) + daysFromVE
}

func newMoonJDE(_ k: Double) -> Double {
    let T  = k / 1236.85
    let T2 = T * T; let T3 = T2 * T; let T4 = T3 * T
    var J  = 2451550.09766 + 29.530588861 * k + 0.00015437 * T2 - 0.000000150 * T3 + 0.00000000073 * T4
    var M  = normDeg(2.5534   + 29.10535670 * k - 0.0000014 * T2 - 0.00000011 * T3)
    var Mp = normDeg(201.5643 + 385.81693528 * k + 0.0107582 * T2 + 0.00001238 * T3 - 0.000000058 * T4)
    var F  = normDeg(160.7108 + 390.67050284 * k - 0.0016118 * T2 - 0.00000227 * T3 + 0.000000011 * T4)
    var O  = normDeg(124.7746 - 1.56375588  * k + 0.0020672 * T2 + 0.00000215 * T3)
    let E  = 1 - 0.002516 * T - 0.0000074 * T2
    let r  = Double.pi / 180
    M *= r; Mp *= r; F *= r; O *= r
    J += -0.40720 * sin(Mp) + 0.17241 * E * sin(M) + 0.01608 * sin(2*Mp)
        + 0.01039 * sin(2*F) + 0.00739 * E * sin(Mp-M) - 0.00514 * E * sin(Mp+M)
        + 0.00208 * E*E * sin(2*M) - 0.00111 * sin(Mp-2*F) - 0.00057 * sin(Mp+2*F)
        + 0.00056 * E * sin(2*Mp+M) - 0.00042 * sin(3*Mp) + 0.00042 * E * sin(M+2*F)
        + 0.00038 * E * sin(M-2*F) - 0.00024 * E * sin(2*Mp-M) - 0.00017 * sin(O)
        - 0.00007 * sin(Mp+2*M) + 0.00004 * sin(2*Mp-2*F) + 0.00004 * sin(3*M)
        + 0.00003 * sin(Mp+M-2*F) + 0.00003 * sin(2*Mp+2*F) - 0.00003 * sin(Mp+M+2*F)
        + 0.00003 * sin(Mp-M+2*F) - 0.00002 * sin(Mp-M-2*F) - 0.00002 * sin(3*Mp+M)
        + 0.00002 * sin(4*Mp)
    return J
}

func kForJDE(_ jde: Double) -> Double { (jde - 2451550.09766) / 29.530588861 }

func moonPhaseAt(_ jde: Double) -> Double {
    let k = kForJDE(jde)
    return ((k.truncatingRemainder(dividingBy: 1)) + 1).truncatingRemainder(dividingBy: 1)
}

// MARK: - Lunar Year Building

struct LunarMonth {
    var num: Int
    var isLeap: Bool
    var startJDE: Double
    var k: Double
    var isEnd: Bool = false
}

private var yearCache: [Int: [LunarMonth]] = [:]

func buildLunarYear(_ wsYear: Int) -> [LunarMonth] {
    if let cached = yearCache[wsYear] { return cached }

    let ws1JDE = findTermJDE(approx: termApprox(wsYear, 270), target: 270)
    let ws2JDE = findTermJDE(approx: termApprox(wsYear + 1, 270), target: 270)

    let ws1_8 = ws1JDE + 8.0/24.0
    var k = (kForJDE(ws1_8)).rounded()
    var nm = newMoonJDE(k)
    if nm > ws1_8 { k -= 1 }
    nm = newMoonJDE(k)
    if newMoonJDE(k + 1) <= ws1_8 { k += 1; nm = newMoonJDE(k) }
    _ = nm

    var moons: [Double] = []
    for i in 0... {
        let m = newMoonJDE(k + Double(i))
        moons.append(m)
        if newMoonJDE(k + Double(i) + 1) + 8.0/24.0 >= ws2JDE + 8.0/24.0 { break }
        if i > 14 { break }
    }

    let hasLeap = moons.count >= 13

    func hasZQ(_ s: Double, _ e: Double) -> Bool {
        let ls = solarLon(s + 8.0/24.0)
        let le = solarLon(e + 8.0/24.0)
        for a in CCC.zhongqiAngles {
            var d = normDeg(a - ls)
            if d < 0.5 { d += 360 }
            let rng = normDeg(le - ls)
            if d <= rng + 2 && rng < 50 { return true }
        }
        return false
    }

    var months: [LunarMonth] = []
    var mNum = 11
    var leapDone = false
    for i in 0..<moons.count {
        let s = moons[i]
        let e = (i + 1 < moons.count) ? moons[i + 1] : ws2JDE
        let zq = hasZQ(s, e)
        var isLeap = false
        if hasLeap && !leapDone && !zq && mNum != 11 { isLeap = true; leapDone = true }
        months.append(LunarMonth(num: mNum, isLeap: isLeap, startJDE: s, k: k + Double(i)))
        if !isLeap { mNum = mNum % 12 + 1 }
    }
    months.append(LunarMonth(num: mNum, isLeap: false,
                              startJDE: newMoonJDE(k + Double(moons.count)),
                              k: k + Double(moons.count), isEnd: true))

    yearCache[wsYear] = months
    return months
}

// MARK: - Date Conversion

struct LunarDate {
    var year: Int
    var month: Int
    var day: Int
    var isLeap: Bool
    var monthDays: Int
}

func gregToLunar(_ date: Date) -> LunarDate {
    let cal = Calendar(identifier: .gregorian)
    let gy = cal.component(.year, from: date)
    let jde = dateToJDE(date) + 8.0/24.0

    for wy in [gy - 1, gy] {
        let months = buildLunarYear(wy)
        for i in 0..<(months.count - 1) {
            let m = months[i]
            let nextStart = months[i + 1].startJDE + 8.0/24.0
            let mStart = m.startJDE + 8.0/24.0
            if jde >= mStart && jde < nextStart {
                let day = Int(floor(jde - mStart)) + 1
                let monthDays = Int((months[i + 1].startJDE - m.startJDE).rounded())
                let month1 = months.first { $0.num == 1 && !$0.isLeap }
                let chYear = (month1 != nil && jde >= month1!.startJDE + 8.0/24.0) ? wy + 1 : wy
                return LunarDate(year: chYear, month: m.num, day: day,
                                  isLeap: m.isLeap, monthDays: monthDays)
            }
        }
    }
    return LunarDate(year: gy, month: 1, day: 1, isLeap: false, monthDays: 30)
}

// MARK: - GanZhi

struct GanZhi {
    var stem: Int
    var branch: Int
    var gz: String
    var idx: Int = 0
}

func yearGZ(_ y: Int) -> GanZhi {
    let si = (((y - 4) % 10) + 10) % 10
    let bi = (((y - 4) % 12) + 12) % 12
    return GanZhi(stem: si, branch: bi, gz: CCC.stems[si] + CCC.branch[bi])
}

func monthGZ(_ date: Date) -> GanZhi {
    let jde = dateToJDE(date) + 8.0/24.0
    let lon = solarLon(jde)
    let jieAngles: [Double] = [315,345,15,45,75,105,135,165,195,225,255,285]
    let jieBranch  = [2,3,4,5,6,7,8,9,10,11,0,1]
    var mBranch = 2
    for i in stride(from: jieAngles.count - 1, through: 0, by: -1) {
        let d = normDeg(lon - jieAngles[i])
        if d < 30 { mBranch = jieBranch[i]; break }
    }
    let cal = Calendar(identifier: .gregorian)
    let gy = cal.component(.year, from: date)
    let actualYear = (lon >= 280 && lon < 315) ? gy - 1 : gy
    let ays = yearGZ(actualYear).stem
    let startStem = (ays % 5 + 1) * 2 % 10
    let mOffset = (mBranch - 2 + 12) % 12
    let mStem = (startStem + mOffset) % 10
    return GanZhi(stem: mStem, branch: mBranch, gz: CCC.stems[mStem] + CCC.branch[mBranch])
}

func dayGZ(_ date: Date) -> GanZhi {
    let cal = Calendar(identifier: .gregorian)
    let y = cal.component(.year, from: date)
    let m = cal.component(.month, from: date)
    let d = cal.component(.day, from: date)
    let jd = Int(gregToJDE(y, m, d) + 0.5)
    let ref = Int(gregToJDE(2000, 1, 1) + 0.5)
    let idx = ((jd - ref + 54) % 60 + 60) % 60
    return GanZhi(stem: idx % 10, branch: idx % 12, gz: CCC.stems[idx % 10] + CCC.branch[idx % 12], idx: idx)
}

func hourGZ(date: Date, dayStem: Int) -> GanZhi {
    let cal = Calendar(identifier: .gregorian)
    let h = cal.component(.hour, from: date)
    let bIdx = h < 1 ? 0 : ((h + 1) / 2) % 12
    let startStem = (dayStem % 5) * 2
    let sIdx = (startStem + bIdx) % 10
    return GanZhi(stem: sIdx, branch: bIdx, gz: CCC.stems[sIdx] + CCC.branch[bIdx])
}

// MARK: - 建除

struct JianZhuInfo {
    var idx: Int
    var name: String
    var yi: [String]
    var ji: [String]
    var luck: Int
    var desc: String
}

func getJianzhu(_ date: Date) -> JianZhuInfo {
    let dg = dayGZ(date)
    let mg = monthGZ(date)
    let idx = (dg.branch - mg.branch + 12) % 12
    return JianZhuInfo(idx: idx, name: CCC.jianzhu[idx],
                        yi: CCC.jzYi[idx], ji: CCC.jzJi[idx],
                        luck: CCC.jzLuck[idx], desc: CCC.jzDesc[idx])
}

// MARK: - 彭祖

struct PengzuInfo {
    var stem: String
    var branch: String
}

func getPengzu(_ date: Date) -> PengzuInfo {
    let dg = dayGZ(date)
    return PengzuInfo(stem: CCC.pengzuStem[dg.stem], branch: CCC.pengzuBranch[dg.branch])
}

// MARK: - 時辰吉凶

enum ShichenFortune: String {
    case excellent = "吉時"
    case good      = "次吉"
    case neutral   = "平時"
    case bad       = "凶時"
    var raw: String { rawValue }
}

func getShichenFortune(date: Date, hourBranch: Int) -> ShichenFortune {
    let dg = dayGZ(date)
    let lucky = CCC.luckyHours[dg.branch]
    if lucky.prefix(2).contains(hourBranch) { return .excellent }
    if lucky.contains(hourBranch) { return .good }
    return hourBranch == (dg.branch + 6) % 12 ? .bad : .neutral
}

// MARK: - 方位

func getChong(_ date: Date) -> String {
    let dg = dayGZ(date)
    let cb = (dg.branch + 6) % 12
    return CCC.branch[cb] + CCC.zodiac[cb]
}

func getSuisha(_ date: Date) -> String {
    let dg = dayGZ(date)
    let sha = ["南","西","北","東"]
    return sha[dg.branch % 4] + "方"
}

// MARK: - 納音

func getNayin(_ idx: Int) -> String { CCC.nayinNames[idx / 2] }

// MARK: - 月相

struct MoonPhase {
    var icon: String
    var name: String
}

func moonPhaseText(_ phase: Double) -> MoonPhase {
    switch phase {
    case ..<0.04, 0.96...: return MoonPhase(icon: "🌑", name: "朔（新月）")
    case ..<0.21:           return MoonPhase(icon: "🌒", name: "眉月")
    case ..<0.29:           return MoonPhase(icon: "🌓", name: "上弦月")
    case ..<0.46:           return MoonPhase(icon: "🌔", name: "漸圓月")
    case ..<0.54:           return MoonPhase(icon: "🌕", name: "望（滿月）")
    case ..<0.71:           return MoonPhase(icon: "🌖", name: "漸虧月")
    case ..<0.79:           return MoonPhase(icon: "🌗", name: "下弦月")
    default:                return MoonPhase(icon: "🌘", name: "殘月")
    }
}

// MARK: - Solar Terms

struct SolarTerm {
    var name: String
    var angle: Double
    var date: Date
    var idx: Int
}

private var termCache: [Int: [SolarTerm]] = [:]

let tpeCal: Calendar = {
    var c = Calendar(identifier: .gregorian)
    c.timeZone = TimeZone(identifier: "Asia/Taipei")!
    return c
}()

func getSolarTermsForYear(_ year: Int) -> [SolarTerm] {
    if let cached = termCache[year] { return cached }
    var terms: [SolarTerm] = []
    for ti in 0..<24 {
        let angle = CCC.termAngles[ti]
        for y in [year - 1, year, year + 1] {
            let approx = termApprox(y, angle)
            let jde = findTermJDE(approx: approx, target: angle)
            let d = jdeToDate(jde)
            if tpeCal.component(.year, from: d) == year {
                terms.append(SolarTerm(name: CCC.termNames[ti], angle: angle, date: d, idx: ti))
            }
        }
    }
    terms.sort { $0.date < $1.date }
    termCache[year] = terms
    return terms
}

struct CurrentTermInfo {
    var current: SolarTerm?
    var next: SolarTerm?
}

func getCurrentTerm(_ date: Date) -> CurrentTermInfo {
    let cal = Calendar(identifier: .gregorian)
    let year = cal.component(.year, from: date)
    let terms = getSolarTermsForYear(year)
    var cur: SolarTerm? = nil
    var next: SolarTerm? = nil
    for t in terms {
        if t.date <= date { cur = t }
        else if next == nil { next = t }
    }
    if next == nil {
        let ny = getSolarTermsForYear(year + 1)
        next = ny.first
    }
    return CurrentTermInfo(current: cur, next: next)
}

// MARK: - 擇日

struct ActivityRule {
    var good: [Int]; var bad: [Int]; var goodS: [Int]; var goodB: [Int]
}

let activityRules: [String: ActivityRule] = [
    "marry":    ActivityRule(good:[2,4,8],    bad:[1,6,11],  goodS:[],      goodB:[2,3,6,11]),
    "business": ActivityRule(good:[2,3,4,10], bad:[6,11],    goodS:[0,2,6], goodB:[3,5,9]),
    "move":     ActivityRule(good:[1,3,8,10], bad:[6,7,11],  goodS:[],      goodB:[3,6,9]),
    "travel":   ActivityRule(good:[0,3,4,10], bad:[6,9,11],  goodS:[],      goodB:[0,2,6]),
    "sign":     ActivityRule(good:[2,3,4,8],  bad:[6,7],     goodS:[0,4,8], goodB:[]),
    "construct":ActivityRule(good:[0,3,8],    bad:[6,11],    goodS:[],      goodB:[2,4,8]),
    "pray":     ActivityRule(good:[0,2,7,8,10],bad:[6],      goodS:[0,4],   goodB:[2,5,9]),
    "medical":  ActivityRule(good:[1,2,7],    bad:[5,6,11],  goodS:[],      goodB:[]),
    "bed":      ActivityRule(good:[2,4,8,9],  bad:[6,7,11],  goodS:[],      goodB:[3,6,9]),
    "burial":   ActivityRule(good:[9,11],     bad:[0,2,6,10],goodS:[],      goodB:[1,4,10]),
]

func scoreDay(_ date: Date, activity: String) -> Int {
    let jz = getJianzhu(date)
    let dg = dayGZ(date)
    let rule = activityRules[activity] ?? activityRules["pray"]!
    var score = 50
    if rule.good.contains(jz.idx)  { score += 20 }
    if rule.bad.contains(jz.idx)   { score -= 25 }
    if jz.idx == 6                 { score -= 30 }
    if rule.goodS.contains(dg.stem)   { score += 10 }
    if rule.goodB.contains(dg.branch) { score += 10 }
    let elem = CCC.wuxingS[dg.stem]
    if ["木","火"].contains(elem) { score += 5 }
    score += jz.luck * 5
    return max(0, min(100, score))
}

func starsFromScore(_ s: Int) -> String {
    switch s {
    case 80...: return "★★★ 大吉"
    case 65...: return "★★ 吉"
    case 50...: return "★ 小吉"
    default:    return "▲ 平"
    }
}
