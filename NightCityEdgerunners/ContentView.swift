import SwiftUI

private enum NC {
    static let ink = Color(red: 0.025, green: 0.035, blue: 0.075)
    static let panel = Color(red: 0.055, green: 0.075, blue: 0.13)
    static let yellow = Color(red: 1.0, green: 0.86, blue: 0.08)
    static let cyan = Color(red: 0.1, green: 0.88, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.18, blue: 0.55)
    static let violet = Color(red: 0.55, green: 0.28, blue: 1.0)
}

private enum NCTab: String, CaseIterable {
    case home = "HOME"
    case crew = "CREW"
    case messages = "MESSAGES"
    case profile = "PROFILE"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .crew: return "person.2.fill"
        case .messages: return "dot.radiowaves.left.and.right"
        case .profile: return "person.crop.square"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: NCTab = .home
    @State private var showSignal = false
    @State private var selectedMessage: FeedMessage?
    @State private var showCrewStatus = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [NC.ink, Color(red: 0.07, green: 0.035, blue: 0.15), NC.ink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            GridPattern()
                .stroke(NC.cyan.opacity(0.10), lineWidth: 0.5)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        homeScreen
                    case .crew:
                        CrewScreen()
                    case .messages:
                        MessagesScreen(selectedMessage: $selectedMessage)
                    case .profile:
                        ProfileScreen()
                    }
                }

                bottomNavigation
            }
        }
        .preferredColorScheme(.dark)
        .alert("SIGNAL CONNECTED", isPresented: $showSignal) {
            Button("ACKNOWLEDGE", role: .cancel) { }
        } message: {
            Text("Your Night City terminal is online. All systems nominal.")
        }
        .alert(item: $selectedMessage) { message in
            Alert(
                title: Text(message.title),
                message: Text(message.detail),
                dismissButton: .default(Text("CLOSE"))
            )
        }
    }

    private var homeScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                header
                hero
                quickStats
                sectionTitle("NIGHT CITY NETWORK", tag: "LIVE")
                networkPanel
                sectionTitle("EDGERUNNER TOOLKIT", tag: "04 MODULES")
                toolGrid
                footer
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("NIGHT CITY")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .tracking(3)
                    .foregroundStyle(NC.yellow)

                Text("EDGERUNNER // PERSONAL TERMINAL")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            Button {
                showSignal = true
            } label: {
                HStack(spacing: 6) {
                    Circle()
                        .fill(NC.cyan)
                        .frame(width: 6, height: 6)
                        .shadow(color: NC.cyan, radius: 5)

                    Text("ONLINE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(1)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .overlay(Rectangle().stroke(NC.cyan.opacity(0.7), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.20, green: 0.08, blue: 0.32),
                            Color(red: 0.05, green: 0.12, blue: 0.24),
                            Color(red: 0.22, green: 0.05, blue: 0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            CitySilhouette().fill(Color.black.opacity(0.55))

            VStack(alignment: .leading, spacing: 8) {
                Text("DAVID × LUCY")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .tracking(3)
                    .foregroundStyle(NC.cyan)

                Text("NO FUTURE\nWITHOUT YOU.")
                    .font(.system(size: 31, weight: .black, design: .rounded))
                    .tracking(-1)
                    .foregroundStyle(.white)
                    .shadow(color: NC.pink.opacity(0.65), radius: 12, x: 2, y: 2)

                Text("NIGHT CITY // AFTER DARK")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundStyle(NC.yellow)
            }
            .padding(20)

            VStack {
                HStack {
                    Text("NC-2077")
                    Spacer()
                    Text("06:00 / 24:00")
                }
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.65))

                Spacer()

                HStack {
                    Spacer()
                    Text("市")
                        .font(.system(size: 55, weight: .black, design: .rounded))
                        .foregroundStyle(NC.yellow.opacity(0.8))
                        .shadow(color: NC.yellow.opacity(0.7), radius: 12)
                }
            }
            .padding(14)
        }
        .frame(height: 245)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(NC.yellow.opacity(0.8), lineWidth: 1))
        .overlay(alignment: .topLeading) {
            Rectangle()
                .fill(NC.yellow)
                .frame(width: 45, height: 3)
                .padding(.leading, 14)
        }
    }

    private var quickStats: some View {
        HStack(spacing: 10) {
            StatTile(label: "REPUTATION", value: "MAX", accent: NC.yellow, icon: "bolt.fill")
            StatTile(label: "CREW LINK", value: "2 / 2", accent: NC.cyan, icon: "person.2.fill")
            StatTile(label: "CREDITS", value: "€ 9,999", accent: NC.pink, icon: "creditcard.fill")
        }
    }

    private var networkPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Label("CITY FEED", systemImage: "dot.radiowaves.left.and.right")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundStyle(NC.cyan)

                Spacer()

                Text("SECURE CHANNEL")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(NC.yellow)
            }
            .padding(14)

            Divider().overlay(NC.cyan.opacity(0.3))

            Button {
                selectedTab = .messages
            } label: {
                FeedRow(time: "23:47", title: "LUCY // NETRUNNER", detail: "ICE breach detected. Route is clear.", color: NC.violet)
            }
            .buttonStyle(.plain)

            Divider().overlay(.white.opacity(0.08))

            Button {
                selectedTab = .messages
            } label: {
                FeedRow(time: "23:52", title: "DAVID // MERC", detail: "Crew status green. Ready to roll.", color: NC.yellow)
            }
            .buttonStyle(.plain)

            Divider().overlay(.white.opacity(0.08))

            Button {
                selectedTab = .messages
            } label: {
                FeedRow(time: "00:03", title: "NIGHT CITY ALERT", detail: "Watson district activity elevated.", color: NC.pink)
            }
            .buttonStyle(.plain)
        }
        .background(NC.panel.opacity(0.92))
        .overlay(Rectangle().stroke(NC.cyan.opacity(0.35), lineWidth: 1))
    }

    private var toolGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            Button { selectedTab = .messages } label: {
                ToolCard(icon: "map.fill", title: "CITY MAP", subtitle: "DISTRICT ACCESS", accent: NC.yellow)
            }
            .buttonStyle(.plain)

            Button { selectedTab = .messages } label: {
                ToolCard(icon: "waveform", title: "AFTERLIFE", subtitle: "AUDIO CHANNEL", accent: NC.pink)
            }
            .buttonStyle(.plain)

            Button { selectedTab = .profile } label: {
                ToolCard(icon: "terminal.fill", title: "NETRUNNER", subtitle: "SYSTEM TOOLS", accent: NC.cyan)
            }
            .buttonStyle(.plain)

            Button { selectedTab = .crew } label: {
                ToolCard(icon: "person.3.fill", title: "THE CREW", subtitle: "DAVID / LUCY", accent: NC.violet)
            }
            .buttonStyle(.plain)
        }
    }

    private var footer: some View {
        HStack {
            Text("ARASAKA // NO THANKS").foregroundStyle(NC.yellow)
            Spacer()
            Text("NC-OS 2.0.0").foregroundStyle(.white.opacity(0.45))
        }
        .font(.system(size: 8, weight: .bold, design: .monospaced))
        .tracking(1)
    }

    private func sectionTitle(_ title: String, tag: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(.white)

            Spacer()

            Text(tag)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(NC.yellow)
        }
    }

    private var bottomNavigation: some View {
        HStack(spacing: 0) {
            ForEach(NCTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 16, weight: .bold))
                        Text(tab.rawValue)
                            .font(.system(size: 7, weight: .black, design: .monospaced))
                            .tracking(0.8)
                    }
                    .foregroundStyle(selectedTab == tab ? NC.yellow : .white.opacity(0.45))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 11)
                    .padding(.bottom, 9)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .background(NC.panel.opacity(0.98))
        .overlay(alignment: .top) {
            Rectangle().fill(NC.cyan.opacity(0.45)).frame(height: 1)
        }
    }
}

private struct CrewScreen: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(title: "EDGERUNNER CREW", subtitle: "PERSONNEL // VERIFIED")

                CharacterCard(
                    name: "DAVID MARTINEZ",
                    role: "MERC // CREW LEADER",
                    status: "READY FOR ACTION",
                    accent: NC.yellow,
                    symbol: "bolt.fill",
                    description: "A determined edgerunner with a reputation for taking impossible jobs. Crew status: green."
                )

                CharacterCard(
                    name: "LUCY",
                    role: "NETRUNNER // RUNNER",
                    status: "CONNECTED",
                    accent: NC.cyan,
                    symbol: "network",
                    description: "A skilled netrunner who moves through the Net with precision. Current channel: secure."
                )

                Text("CREW LINK // 2 OF 2 ACTIVE")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(NC.yellow)
                    .padding(.top, 4)
            }
            .padding(20)
        }
    }
}

private struct MessagesScreen: View {
    @Binding var selectedMessage: FeedMessage?

    private let messages = [
        FeedMessage(time: "23:47", title: "LUCY // NETRUNNER", detail: "ICE breach detected. Route is clear.", color: NC.violet),
        FeedMessage(time: "23:52", title: "DAVID // MERC", detail: "Crew status green. Ready to roll.", color: NC.yellow),
        FeedMessage(time: "00:03", title: "NIGHT CITY ALERT", detail: "Watson district activity elevated.", color: NC.pink),
        FeedMessage(time: "00:11", title: "LUCY // PRIVATE CHANNEL", detail: "Stay close. I'll guide you through the system.", color: NC.cyan),
        FeedMessage(time: "00:18", title: "DAVID // CREW CHANNEL", detail: "Preem. Let's get moving.", color: NC.yellow)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                ScreenHeader(title: "CITY NETWORK", subtitle: "MESSAGES // ENCRYPTED")

                HStack {
                    Circle().fill(NC.cyan).frame(width: 7, height: 7)
                        .shadow(color: NC.cyan, radius: 5)
                    Text("SECURE CHANNEL ACTIVE")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundStyle(NC.cyan)
                    Spacer()
                    Text("5 LOGS")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(NC.yellow)
                }
                .padding(13)
                .background(NC.panel)
                .overlay(Rectangle().stroke(NC.cyan.opacity(0.35), lineWidth: 1))

                VStack(spacing: 0) {
                    ForEach(messages) { message in
                        Button {
                            selectedMessage = message
                        } label: {
                            FeedRow(time: message.time, title: message.title, detail: message.detail, color: message.color)
                        }
                        .buttonStyle(.plain)

                        if message.id != messages.last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
                .background(NC.panel.opacity(0.92))
                .overlay(Rectangle().stroke(NC.cyan.opacity(0.35), lineWidth: 1))

                Text("TAP ANY MESSAGE TO OPEN ITS TRANSMISSION")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .tracking(0.8)
                    .foregroundStyle(.white.opacity(0.45))
            }
            .padding(20)
        }
    }
}

private struct ProfileScreen: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(title: "PERSONAL TERMINAL", subtitle: "USER PROFILE // NC-2077")

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        ZStack {
                            Rectangle().fill(NC.yellow.opacity(0.12))
                                .frame(width: 58, height: 58)
                                .overlay(Rectangle().stroke(NC.yellow, lineWidth: 1))
                            Image(systemName: "person.fill")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundStyle(NC.yellow)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("NIGHT CITY USER")
                                .font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundStyle(.white)
                            Text("EDGERUNNER // VERIFIED")
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .foregroundStyle(NC.cyan)
                        }
                    }

                    Divider().overlay(.white.opacity(0.12))

                    ProfileLine(label: "REPUTATION", value: "MAX", accent: NC.yellow)
                    ProfileLine(label: "CREDITS", value: "€ 9,999", accent: NC.pink)
                    ProfileLine(label: "CREW STATUS", value: "2 / 2 ACTIVE", accent: NC.cyan)
                    ProfileLine(label: "SYSTEM", value: "NC-OS 2.0.0", accent: NC.violet)
                }
                .padding(16)
                .background(NC.panel)
                .overlay(Rectangle().stroke(NC.cyan.opacity(0.35), lineWidth: 1))

                VStack(alignment: .leading, spacing: 8) {
                    Text("SYSTEM NOTICE")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(NC.yellow)
                    Text("This is your personal Night City interface. More customization modules and visual upgrades can be added in future releases.")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.65))
                }
                .padding(15)
                .background(NC.panel.opacity(0.75))
            }
            .padding(20)
        }
    }
}

private struct ScreenHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 17, weight: .black, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(NC.yellow)

            Text(subtitle)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .tracking(1.2)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 5)
    }
}

private struct CharacterCard: View {
    let name: String
    let role: String
    let status: String
    let accent: Color
    let symbol: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top) {
                ZStack {
                    Rectangle().fill(accent.opacity(0.12))
                        .frame(width: 58, height: 58)
                        .overlay(Rectangle().stroke(accent.opacity(0.8), lineWidth: 1))
                    Image(systemName: symbol)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(accent)
                        .shadow(color: accent.opacity(0.6), radius: 8)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                    Text(role)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundStyle(accent)
                    Text(status)
                        .font(.system(size: 7, weight: .black, design: .monospaced))
                        .tracking(1)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()
            }

            Text(description)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)

            Rectangle().fill(accent.opacity(0.6)).frame(height: 2)
        }
        .padding(15)
        .background(NC.panel)
        .overlay(Rectangle().stroke(accent.opacity(0.4), lineWidth: 1))
    }
}

private struct ProfileLine: View {
    let label: String
    let value: String
    let accent: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(accent)
        }
    }
}

private struct FeedMessage: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let detail: String
    let color: Color
}

private struct StatTile: View {
    let label: String
    let value: String
    let accent: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(accent)

            Text(value)
                .font(.system(size: 16, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(label)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(.white.opacity(0.55))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(NC.panel)
        .overlay(alignment: .top) {
            Rectangle().fill(accent).frame(height: 2)
        }
    }
}

private struct FeedRow: View {
    let time: String
    let title: String
    let detail: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(time)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .frame(width: 42, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundStyle(.white)

                Text(detail)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Circle()
                .fill(color)
                .frame(width: 5, height: 5)
                .shadow(color: color, radius: 5)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

private struct ToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(accent)
                .shadow(color: accent.opacity(0.7), radius: 8)

            Text(title)
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .padding(14)
        .background(NC.panel)
        .overlay(Rectangle().stroke(accent.opacity(0.4), lineWidth: 1))
    }
}

private struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        stride(from: 0, through: rect.width, by: 28).forEach { x in
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x, y: rect.height))
        }
        stride(from: 0, through: rect.height, by: 28).forEach { y in
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: rect.width, y: y))
        }
        return p
    }
}

private struct CitySilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.height * 0.72))
        let buildings: [(CGFloat, CGFloat)] = [
            (0.08, 0.35), (0.17, 0.55), (0.25, 0.40), (0.34, 0.66),
            (0.43, 0.48), (0.52, 0.60), (0.62, 0.36), (0.72, 0.58),
            (0.82, 0.42), (0.91, 0.63), (1.0, 0.38)
        ]
        for (x, h) in buildings {
            p.addLine(to: CGPoint(x: rect.width * x, y: rect.height * (1 - h)))
            p.addLine(to: CGPoint(x: rect.width * x, y: rect.height))
        }
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        return p
    }
}
