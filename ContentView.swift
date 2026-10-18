import FamilyControls
import ManagedSettings
import AVFoundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: WellPhoneStore
    @EnvironmentObject private var appBlocking: AppBlockingStore
    @Environment(\.scenePhase) private var scenePhase
    @State private var tab = 0
    @State private var showPlanSettings = false
    @State private var redirectApp = "TikTok"

    var body: some View {
        Group {
            if store.hasOnboarded {
                TabView(selection: $tab) {
                    TodayView(tab: $tab, redirectApp: $redirectApp, onPlan: { showPlanSettings = true }).tabItem { Label("Today", systemImage: "house") }.tag(0)
                    RoutineView(onPlan: { showPlanSettings = true }).tabItem { Label("Routine", systemImage: "clock") }.tag(1)
                    RedirectView(tab: $tab, appName: $redirectApp, onPlan: { showPlanSettings = true }).tabItem { Label("Redirect", systemImage: "arrowshape.turn.up.right") }.tag(2)
                    InsightsView(onPlan: { showPlanSettings = true }).tabItem { Label("Insights", systemImage: "chart.bar") }.tag(3)
                }
                .toolbarBackground(.white.opacity(0.96), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .tint(WellPhoneStyle.green)
                .sheet(isPresented: $showPlanSettings) { PlanSettingsSheet() }
            } else {
                OnboardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(WellPhoneStyle.canvas.ignoresSafeArea())
        .preferredColorScheme(.light)
        .onAppear(perform: openRedirectIfRequested)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                appBlocking.refreshAuthorization()
                openRedirectIfRequested()
            }
        }
    }

    private func openRedirectIfRequested() {
        let defaults = UserDefaults(suiteName: "group.com.wellphone.app")
        guard defaults?.bool(forKey: "wellphone.redirectAfterShield") == true else { return }
        defaults?.removeObject(forKey: "wellphone.redirectAfterShield")
        redirectApp = "An app"
        tab = 2
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var store: WellPhoneStore
    @State private var selected: Set<String> = []
    @State private var custom = ""
    @State private var fitnessLevel: FitnessLevel = .beginner
    private let suggestions = ["Do Better Academically", "Get Job", "Better Sleep", "Increase Fitness", "Improve my Home", "Learn a Creative Skill", "Write a Book", "Read more"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                BrandMark().padding(.top, 28)
                Text("Make room for what matters.").font(.system(size: 34, weight: .bold, design: .rounded)).tracking(-1.5)
                Text("Choose a few things you want WellPhone to help make space for.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(suggestions, id: \.self) { goal in
                        Button { toggle(goal) } label: {
                            HStack(alignment: .top, spacing: 9) {
                                Image(systemName: selected.contains(goal) ? "checkmark.circle.fill" : "circle").foregroundStyle(selected.contains(goal) ? WellPhoneStyle.green : WellPhoneStyle.muted)
                                Text(goal).font(.subheadline.weight(.medium)).foregroundStyle(WellPhoneStyle.ink).multilineTextAlignment(.leading)
                            }.frame(maxWidth: .infinity, minHeight: 58, alignment: .leading).padding(12).webCard(15, fill: .white, border: selected.contains(goal) ? WellPhoneStyle.green : WellPhoneStyle.border)
                        }.buttonStyle(.plain)
                    }
                }
                HStack {
                    TextField("Add your own goal", text: $custom).textFieldStyle(.roundedBorder)
                    Button("Add") { addCustom() }.fontWeight(.semibold)
                }
                if !selected.isEmpty {
                    Text("YOUR GOALS").font(.caption2.weight(.bold)).tracking(1.2).foregroundStyle(WellPhoneStyle.muted)
                    ForEach(Array(selected).sorted(), id: \.self) { goal in
                        HStack { Image(systemName: "leaf.fill").foregroundStyle(WellPhoneStyle.green); Text(goal); Spacer(); Button { selected.remove(goal) } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(WellPhoneStyle.muted) } }.font(.subheadline).padding(12).background(.white, in: RoundedRectangle(cornerRadius: 13))
                    }
                }
                if selected.contains(where: Self.isFitnessGoal) { FitnessLevelPicker(selection: $fitnessLevel) }
                Button { store.finishOnboarding(goals: Array(selected).sorted(), fitnessLevel: fitnessLevel) } label: { Text("Continue").frame(maxWidth: .infinity).padding(15).fontWeight(.bold).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 15)) }.disabled(selected.isEmpty).opacity(selected.isEmpty ? 0.5 : 1)
            }.padding(20).frame(maxWidth: 480).frame(maxWidth: .infinity)
        }.background(WellPhoneStyle.canvas)
    }

    private static func isFitnessGoal(_ goal: String) -> Bool { ["increase fitness", "get stronger"].contains(goal.lowercased()) }
    private func toggle(_ goal: String) {
        if selected.contains(goal) { selected.remove(goal) } else { selected.insert(goal) }
    }
    private func addCustom() {
        let value = custom.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else { return }
        selected.insert(value); custom = ""
    }
}

private struct FitnessLevelPicker: View {
    @Binding var selection: FitnessLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YOUR FITNESS LEVEL").font(.caption2.bold()).tracking(1.1).foregroundStyle(WellPhoneStyle.muted)
            Text("What feels like the right fit?").font(.headline).foregroundStyle(WellPhoneStyle.ink)
            ForEach(FitnessLevel.allCases) { level in
                Button { selection = level } label: {
                    HStack(spacing: 10) {
                        Image(systemName: selection == level ? "largecircle.fill.circle" : "circle").foregroundStyle(WellPhoneStyle.green)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(level.title).font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.ink)
                            Text(level.description).font(.caption).foregroundStyle(WellPhoneStyle.muted)
                        }
                        Spacer()
                    }.padding(11).frame(maxWidth: .infinity, alignment: .leading)
                        .background(selection == level ? WellPhoneStyle.lime.opacity(0.42) : .white, in: RoundedRectangle(cornerRadius: 13))
                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(selection == level ? WellPhoneStyle.green : WellPhoneStyle.border, lineWidth: 1))
                }.buttonStyle(.plain)
            }
            Text("You can change this any time in Your plan.").font(.caption).foregroundStyle(WellPhoneStyle.muted)
        }.padding(14).webCard(18)
    }
}

struct TodayView: View {
    @EnvironmentObject private var store: WellPhoneStore
    @EnvironmentObject private var appBlocking: AppBlockingStore
    @Environment(\.openURL) private var openURL
    @Binding var tab: Int
    @Binding var redirectApp: String
    var onPlan: () -> Void = {}
    @State private var appMessage: String?

    private let apps: [(String, String, Color, String?)] = [
        ("TikTok", "music.note", Color(red: 32/255, green: 33/255, blue: 37/255), "redirect"),
        ("Instagram", "camera", Color(red: 224/255, green: 92/255, blue: 115/255), "redirect"),
        ("YouTube", "play.fill", Color(red: 238/255, green: 69/255, blue: 69/255), "redirect"),
        ("Safari", "safari.fill", Color(red: 225/255, green: 239/255, blue: 204/255), "redirect"),
        ("Calendar", "calendar", Color(red: 229/255, green: 238/255, blue: 250/255), "calshow://"),
        ("Photos", "photo.on.rectangle", Color(red: 247/255, green: 229/255, blue: 238/255), "photos-redirect://"),
        ("Reminders", "checklist", Color(red: 246/255, green: 239/255, blue: 215/255), "x-apple-reminderkit://"),
        ("News", "newspaper.fill", Color(red: 240/255, green: 225/255, blue: 220/255), "applenews://")
    ]

    private var dateLine: String { Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()).uppercased() }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 17) {
                    AppHeader(onPlan: onPlan).padding(.top, 8)
                    Text(dateLine).font(.caption2.weight(.bold)).tracking(1.2).foregroundStyle(WellPhoneStyle.muted).padding(.top, 14)
                    Text("Make room for\nwhat matters.").font(.system(size: 32, weight: .bold, design: .rounded)).tracking(-1.4).lineSpacing(-3)
                    Text("Your phone can support the life you want to live.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("A GOAL YOU CHOSE").font(.caption2.weight(.bold)).tracking(1.1).foregroundStyle(.white.opacity(0.75))
                        Text(store.chosenGoals.first ?? "Your goals, your way").font(.title3.bold()).foregroundStyle(.white)
                        Text("When an app pulls you off course, choose what you want to do next.").font(.subheadline).foregroundStyle(.white.opacity(0.82))
                        Button { tab = 2 } label: { Label("Try an app check-in", systemImage: "arrowshape.turn.up.right.fill").font(.subheadline.bold()).padding(.horizontal, 14).padding(.vertical, 11).foregroundStyle(WellPhoneStyle.ink).background(WellPhoneStyle.lime, in: RoundedRectangle(cornerRadius: 13)) }.padding(.top, 4)
                    }.padding(18).frame(maxWidth: .infinity, alignment: .leading).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 22))
                    HStack { Text("Open an app").font(.headline); Spacer(); Text("Pause before opening").font(.caption.weight(.semibold)).foregroundStyle(WellPhoneStyle.green).padding(.horizontal, 10).padding(.vertical, 6).background(WellPhoneStyle.lime.opacity(0.55), in: Capsule()) }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 9), count: 4), spacing: 9) {
                        ForEach(apps, id: \.0) { app in
                            Button { openApp(app) } label: {
                                VStack(spacing: 7) {
                                    Image(systemName: app.1).font(.system(size: 19, weight: .semibold)).foregroundStyle(app.0 == "Safari" || app.0 == "Messages" ? WellPhoneStyle.green : .white).frame(width: 38, height: 38).background(app.2, in: RoundedRectangle(cornerRadius: 13))
                                    Text(app.0).font(.caption.weight(.semibold)).foregroundStyle(WellPhoneStyle.ink).lineLimit(1).minimumScaleFactor(0.8)
                                    if app.0 == "Safari" { Text("BLOCKED").font(.system(size: 8, weight: .bold)).tracking(0.4).foregroundStyle(.red) }
                                }.frame(maxWidth: .infinity, minHeight: app.0 == "Safari" ? 88 : 82).padding(.vertical, 7).webCard(17)
                            }.buttonStyle(.plain)
                        }
                        ForEach(Array(appBlocking.selection.applicationTokens), id: \.self) { token in
                            Button {
                                redirectApp = "An app"
                                tab = 2
                            } label: {
                                VStack(spacing: 7) {
                                    Label(token).labelStyle(.iconOnly).font(.system(size: 19, weight: .semibold))
                                        .frame(width: 38, height: 38)
                                        .background(WellPhoneStyle.lime.opacity(0.55), in: RoundedRectangle(cornerRadius: 13))
                                    Label(token).labelStyle(.titleOnly).font(.caption.weight(.semibold))
                                        .foregroundStyle(WellPhoneStyle.ink).lineLimit(1).minimumScaleFactor(0.7)
                                    Text("BLOCKED").font(.system(size: 8, weight: .bold)).tracking(0.4).foregroundStyle(.red)
                                }.frame(maxWidth: .infinity, minHeight: 88).padding(.vertical, 7).webCard(17)
                            }.buttonStyle(.plain)
                        }
                    }
                    if let availabilityEndDate = appBlocking.availabilityEndDate, availabilityEndDate > .now {
                        VStack(alignment: .leading, spacing: 9) {
                            Label("One app is temporarily available", systemImage: "hourglass")
                                .font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green)
                            Text("Access ends at \(availabilityEndDate.formatted(date: .omitted, time: .shortened)). Everything else stays blocked.")
                                .font(.caption).foregroundStyle(WellPhoneStyle.muted)
                            Button { appBlocking.endAvailabilityWindow() } label: {
                                Text("End access now and block the app")
                                    .font(.subheadline.bold()).frame(maxWidth: .infinity).padding(12)
                                    .foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 12))
                            }
                        }.padding(14).webCard(18)
                    }
                    Text("Safari is included as the blocked-app demo. To shield Safari or specific websites, select them in Your plan → Choose apps and websites to shield. Other selected apps appear here too.")
                        .font(.caption).foregroundStyle(WellPhoneStyle.muted).padding(.horizontal, 3)
                    HStack(alignment: .top, spacing: 10) {
                        Text("✳").font(.title3)
                        Text(.init("**Your phone, your choice.** WellPhone makes room for the things you care about. You can continue to any app.")).font(.caption).foregroundStyle(WellPhoneStyle.green)
                    }.padding(14).frame(maxWidth: .infinity, alignment: .leading).background(WellPhoneStyle.lime.opacity(0.42), in: RoundedRectangle(cornerRadius: 17))
                    HStack { Text("Your goals").font(.headline); Spacer(); Button("Manage") { onPlan() }.font(.subheadline.weight(.semibold)) }
                    VStack(spacing: 9) {
                        ForEach(store.chosenGoals, id: \.self) { goal in
                            let steps = store.smallSteps(for: goal)
                            let completed = steps.filter { store.isSmallStepComplete(goal: goal, step: $0) }.count
                            VStack(alignment: .leading, spacing: 11) {
                                HStack(spacing: 10) {
                                    Image(systemName: "leaf.fill").font(.subheadline).foregroundStyle(WellPhoneStyle.green).frame(width: 38, height: 38).background(WellPhoneStyle.lime.opacity(0.55), in: RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading, spacing: 3) { Text(goal).font(.subheadline.bold()); Text("\(completed) of \(steps.count) small steps complete").font(.caption).foregroundStyle(WellPhoneStyle.muted) }
                                    Spacer()
                                }
                                ProgressView(value: Double(completed), total: Double(max(steps.count, 1))).tint(WellPhoneStyle.green)
                                ForEach(steps, id: \.self) { step in
                                    let exercise = store.fitnessExercises().first(where: { $0.title == step })
                                    let progress = exercise.map { store.fitnessProgressValue(goal: goal, exercise: $0) } ?? 0
                                    Button { store.toggleSmallStep(goal: goal, step: step) } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: store.isSmallStepComplete(goal: goal, step: step) ? "checkmark.square.fill" : "square").foregroundStyle(store.isSmallStepComplete(goal: goal, step: step) ? WellPhoneStyle.green : WellPhoneStyle.border)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(step).font(.subheadline).strikethrough(store.isSmallStepComplete(goal: goal, step: step)).foregroundStyle(store.isSmallStepComplete(goal: goal, step: step) ? WellPhoneStyle.muted : WellPhoneStyle.ink)
                                                if let exercise, progress > 0, !store.isSmallStepComplete(goal: goal, step: step) {
                                                    Text("\(progress) of \(exercise.target) \(exercise.unit) so far").font(.caption).foregroundStyle(WellPhoneStyle.green)
                                                }
                                            }
                                            Spacer(minLength: 0)
                                        }.contentShape(Rectangle())
                                    }.buttonStyle(.plain)
                                }
                            }.padding(15).webCard(22)
                        }
                    }
                    Text("Your phone, your choice. Continue to any app whenever you want.").font(.caption).foregroundStyle(WellPhoneStyle.muted).padding(.vertical, 7)
                }.padding(.horizontal, 20).padding(.bottom, 28).frame(maxWidth: 480).frame(maxWidth: .infinity)
            }.background(WellPhoneStyle.canvas).toolbar(.hidden, for: .navigationBar)
                .alert("Open app", isPresented: Binding(get: { appMessage != nil }, set: { if !$0 { appMessage = nil } })) { Button("OK", role: .cancel) { appMessage = nil } } message: { Text(appMessage ?? "") }
        }
    }

    private func openApp(_ app: (String, String, Color, String?)) {
        if app.3 == "redirect" {
            redirectApp = app.0
            tab = 2
        } else if let address = app.3, let url = URL(string: address) {
            openURL(url) { accepted in
                if !accepted {
                    appMessage = "\(app.0) couldn’t be opened from WellPhone on this device. Try opening it from your Home Screen."
                }
            }
        } else {
            appMessage = "Clock doesn’t provide a public link for opening it from WellPhone. You can open it from your Home Screen."
        }
    }
}

struct DailyGoalsSheet: View {
    @EnvironmentObject private var store: WellPhoneStore
    @Environment(\.dismiss) private var dismiss
    let date: Date
    let title: String
    @State private var goals: [String] = ["", "", ""]

    var body: some View {
        NavigationStack {
            Form {
                Section { Text("Choose up to three things you want to make time for.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted) }
                Section("YOUR GOALS") {
                    ForEach(0..<3, id: \.self) { index in TextField("Goal \(index + 1)", text: $goals[index]).textInputAutocapitalization(.sentences) }
                }
            }.navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) { Button("Save") { store.saveGoals(goals, for: date); dismiss() } }
                }
                .onAppear { goals = store.goals(for: date) }
        }.presentationDetents([.medium, .large])
    }
}

struct RoutineView: View {
    @EnvironmentObject private var store: WellPhoneStore
    var onPlan: () -> Void = {}
    @State private var kind: RoutineKind = Self.contextRoutine()
    @State private var dailyGoals = ["", "", ""]
    @State private var tomorrowGoals = ["", "", ""]
    @State private var statuses = [String](repeating: "", count: 3)
    @State private var message: String?
    @State private var showResetConfirmation = false

    private var routineDate: Date {
        guard kind == .windDown, Calendar.current.component(.hour, from: .now) < 4 else { return .now }
        return Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now
    }
    private var record: RoutineRecord { store.routine(kind, date: routineDate) }
    private var currentStep: String? { kind.steps.indices.contains(record.index) ? kind.steps[record.index] : nil }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AppHeader(onPlan: onPlan).padding(.top, 8)
                    Text("YOUR DAILY RHYTHM · \(Date.now.formatted(date: .omitted, time: .shortened).uppercased())").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted).padding(.top, 10)
                    Text("A routine that\nfits right now.").font(.system(size: 30, weight: .bold, design: .rounded)).tracking(-1.2)
                    Text("Both routines are here whenever you need them. Follow the full checklist, adjust it, or skip what doesn’t fit.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                    Picker("Routine", selection: $kind) {
                        ForEach(RoutineKind.allCases) { item in Label(item.title, systemImage: item.symbol).tag(item) }
                    }.pickerStyle(.segmented).onChange(of: kind) { _, _ in resetDrafts() }
                    VStack(alignment: .leading, spacing: 15) {
                        HStack { Image(systemName: kind.symbol).font(.title2).foregroundStyle(WellPhoneStyle.green); VStack(alignment: .leading) { Text(kind.window.uppercased()).font(.caption2.bold()).tracking(0.8).foregroundStyle(WellPhoneStyle.muted); Text(kind.title).font(.headline) }; Spacer(); Button("Reset") { showResetConfirmation = true }.font(.caption.bold()).foregroundStyle(WellPhoneStyle.green) }
                        if let currentStep {
                            Text("STEP \(record.index + 1) OF \(kind.steps.count)").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
                            ProgressView(value: Double(record.index), total: Double(kind.steps.count)).tint(WellPhoneStyle.green)
                            stepContent(currentStep)
                        } else {
                            Label("You’ve reached the end of this routine.", systemImage: "checkmark.circle.fill").font(.headline).foregroundStyle(WellPhoneStyle.green)
                        }
                    }.padding(18).frame(maxWidth: .infinity, alignment: .leading).webCard(22)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("THE WHOLE ROUTINE").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
                        ForEach(Array(kind.steps.enumerated()), id: \.offset) { index, title in
                            HStack(spacing: 11) {
                                let isComplete = record.completed.contains(index)
                                let isSkipped = record.skipped.contains(index)
                                Image(systemName: isComplete ? "checkmark.circle.fill" : (isSkipped ? "forward.end.circle" : (index == record.index ? "circle.inset.filled" : "circle"))).foregroundStyle(isComplete ? WellPhoneStyle.green : WellPhoneStyle.muted)
                                Text(title).font(.subheadline).strikethrough(isSkipped).foregroundStyle(isComplete || isSkipped ? WellPhoneStyle.muted : WellPhoneStyle.ink)
                            }
                        }
                    }.padding(17).frame(maxWidth: .infinity, alignment: .leading).webCard(22)
                    Text("These are full everyday tasks, not a timer or a test. Complete or skip steps and adjust the routine to fit your life.").font(.caption).foregroundStyle(WellPhoneStyle.muted).padding(13).background(WellPhoneStyle.lime.opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
                }.padding(.horizontal, 20).padding(.bottom, 28).frame(maxWidth: 480).frame(maxWidth: .infinity)
            }.background(WellPhoneStyle.canvas).toolbar(.hidden, for: .navigationBar)
                .onAppear { resetDrafts() }
                .alert("", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) { Button("OK", role: .cancel) { message = nil } } message: { Text(message ?? "") }
                .confirmationDialog("Reset \(kind.title)?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                    Button("Reset this routine", role: .destructive) { store.resetRoutine(kind, date: routineDate); resetDrafts() }
                    Button("Cancel", role: .cancel) { }
                } message: { Text("This clears today’s completed and skipped steps for this routine.") }
        }
    }

    @ViewBuilder private func stepContent(_ title: String) -> some View {
        if kind == .morning && record.index == 1 {
            Text("Choose the things you want to make time for today. You can edit these later.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            goalFields($dailyGoals, placeholder: "Something you want to do today")
            Button { saveMorningGoals() } label: { Label("Save goals & continue", systemImage: "arrow.right").frame(maxWidth: .infinity).padding(14).fontWeight(.bold).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14)) }
        } else if kind == .windDown && record.index == 0 {
            Text("Take a moment to notice how today went. Every answer is okay.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            let todays = store.goals(for: routineDate).filter { !$0.isEmpty }
            if todays.isEmpty {
                Text("No goals were saved for today. That’s okay.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            } else {
                ForEach(Array(todays.enumerated()), id: \.offset) { index, goal in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goal).font(.subheadline.weight(.semibold))
                        HStack(spacing: 7) { reflectionButton("Met", value: "met", index: index); reflectionButton("In progress", value: "in-progress", index: index); reflectionButton("Not today", value: "not-today", index: index) }
                    }.padding(11).background(WellPhoneStyle.canvas, in: RoundedRectangle(cornerRadius: 13))
                }
            }
            Text("OPTIONAL · TOMORROW").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted).padding(.top, 7)
            Text("Start adding goals for tomorrow. You can fill in the rest in Morning Start.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            goalFields($tomorrowGoals, placeholder: "Add a goal for tomorrow")
            Button { saveEvening(todays) } label: { Label("Save & continue", systemImage: "arrow.right").frame(maxWidth: .infinity).padding(14).fontWeight(.bold).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14)) }
        } else {
            Text(title).font(.title3.bold())
            Text(stepDetail(for: title)).font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            Button { advance() } label: { Label("Done with this step", systemImage: "arrow.right").frame(maxWidth: .infinity).padding(14).fontWeight(.bold).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14)) }
        }
        Button("Skip this step") { advance(skipped: true) }.font(.subheadline.weight(.semibold)).frame(maxWidth: .infinity).padding(.top, 2)
    }

    private func goalFields(_ binding: Binding<[String]>, placeholder: String) -> some View {
        VStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in TextField("Goal \(index + 1) · \(placeholder)", text: binding[index]).textFieldStyle(.roundedBorder).textInputAutocapitalization(.sentences) }
        }
    }

    private func reflectionButton(_ title: String, value: String, index: Int) -> some View {
        Button { if statuses.count <= index { statuses += Array(repeating: "", count: index - statuses.count + 1) }; statuses[index] = value } label: {
            Text(title).font(.caption2.weight(.semibold)).padding(.horizontal, 9).padding(.vertical, 8).foregroundStyle(statuses.indices.contains(index) && statuses[index] == value ? .white : WellPhoneStyle.green).background(statuses.indices.contains(index) && statuses[index] == value ? WellPhoneStyle.green : .white, in: Capsule())
        }.buttonStyle(.plain)
    }

    private func saveMorningGoals() {
        store.saveGoals(dailyGoals, for: routineDate)
        advance()
    }

    private func saveEvening(_ todays: [String]) {
        if !todays.isEmpty && (todays.indices.contains(where: { !statuses.indices.contains($0) || statuses[$0].isEmpty })) {
            message = "Choose a reflection for each goal, or skip this step."
            return
        }
        if !todays.isEmpty { store.saveReflection(goals: todays, statuses: todays.indices.map { statuses[$0] }, date: routineDate) }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: routineDate) ?? .now
        store.saveGoals(tomorrowGoals, for: tomorrow)
        advance()
    }

    private func advance(skipped: Bool = false) { store.completeStep(kind, date: routineDate, total: kind.steps.count, skipped: skipped); resetDrafts() }
    private func resetDrafts() {
        dailyGoals = store.goals(for: routineDate)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: routineDate) ?? .now
        tomorrowGoals = store.goals(for: tomorrow)
        statuses = Array(repeating: "", count: 3)
    }
    private func stepDetail(for title: String) -> String {
        switch title {
        case "Get up and open the curtains": return "Start the day when you’re ready."
        case "Pack your bag for tomorrow and put it by the door": return "Add anything you need for school, work, or your plans."
        case "Clean one area": return "Choose one area to reset. It can be small or take as long as you need."
        case "Set any alarms you need for tomorrow": return "Set or adjust your alarms in the Clock app."
        case "Close the curtains": return "Set up your room the way you like it for sleep."
        case "Choose a quiet last activity": return "Read, listen to something, or settle in for sleep."
        default: return "Adjust this step to match what works for you."
        }
    }
    private static func contextRoutine() -> RoutineKind {
        let hour = Calendar.current.component(.hour, from: .now)
        return hour >= 4 && hour < 12 ? .morning : .windDown
    }
}

struct RedirectView: View {
    @EnvironmentObject private var store: WellPhoneStore
    @EnvironmentObject private var appBlocking: AppBlockingStore
    @Environment(\.openURL) private var openURL
    @Binding var tab: Int
    @Binding var appName: String
    var onPlan: () -> Void = {}
    @State private var reason = ""
    @State private var selectedReason: String?
    @State private var selected: String?
    @State private var showBreathingExercise = false
    @State private var quickIdeas = ["Read a fun Wikipedia page", "Listen to a new music release"]
    @State private var message: String?
    @State private var showAvailabilityOptions = false
    @State private var showAccessAppPicker = false
    @State private var availabilityMinutes = 15
    @State private var allowedApplicationToken: ApplicationToken?
    @State private var applicationsBeforeAccessPicker: Set<ApplicationToken> = []
    @State private var completionTask: RedirectTask?
    @State private var showPopOutTimerSetup = false
    @State private var fitnessGuideStep = 0
    @State private var fitnessCount = 0
    @State private var savedFitnessWin: String?
    @State private var fitnessAudioEnabled = false
    @State private var fitnessTimerRunning = false
    @State private var fitnessSecondsRemaining = 0
    @State private var fitnessTimerTask: Task<Void, Never>?
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    private let reasons = [("💬", "See what my friends are up to"), ("🔎", "Find something specific"), ("☁️", "Take a quick break"), ("✨", "I opened it automatically")]
    private var quickIdeaDetails: [String: (String, String)] {
        var details: [String: (String, String)] = [
        "Read a fun Wikipedia page": ("Pick a topic you’ve always wondered about", "🌐"),
        "Listen to a new music release": ("Put on one new song and just listen", "🎧"),
        "Follow a quick guided stretch": ("A short reset for your body", "🧘"),
        "Try a short meditation": ("A couple of quiet minutes, at your pace", "🌿"),
        "Get a glass of water and take three slow breaths": ("A small, screen-free reset", "💧"),
        "Read a short poem": ("A small change of pace", "📜"),
        "Step outside for a few minutes": ("A brief change of scenery", "🌤️")
        ]
        for exercise in store.fitnessExercises() { details[exercise.title] = (exercise.summary, exercise.icon) }
        return details
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AppHeader(onPlan: onPlan).padding(.top, 8)
                    Button { tab = 0 } label: { Label("Back", systemImage: "arrow.left").font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green) }.buttonStyle(.plain).padding(.top, 9)
                    Text("A MOMENT TO CHOOSE").font(.caption2.bold()).tracking(1.1).foregroundStyle(WellPhoneStyle.muted).padding(.top, 8)
                    Text("\(appName) can wait a moment.").font(.system(size: 29, weight: .bold, design: .rounded)).tracking(-1)
                    Text("What would feel useful right now? You’re in control.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                    HStack(spacing: 11) {
                        Image(systemName: appIcon).font(.system(size: 19, weight: .semibold)).foregroundStyle(.white).frame(width: 38, height: 38).background(Color(red: 32/255, green: 33/255, blue: 37/255), in: RoundedRectangle(cornerRadius: 13))
                        VStack(alignment: .leading, spacing: 3) { Text(appName).font(.subheadline.bold()); Text("Available after your check-in").font(.caption).foregroundStyle(WellPhoneStyle.muted) }
                        Spacer()
                    }.padding(13).background(WellPhoneStyle.lime.opacity(0.36), in: RoundedRectangle(cornerRadius: 17))
                    Text("What brought you here today?").font(.headline).padding(.top, 4)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 9), GridItem(.flexible(), spacing: 9)], spacing: 9) {
                        ForEach(reasons, id: \.1) { item in
                            Button { selectedReason = item.1 } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.0).font(.title3)
                                    Text(item.1).font(.subheadline).multilineTextAlignment(.leading).foregroundStyle(WellPhoneStyle.ink)
                                    Spacer(minLength: 0)
                                }.frame(maxWidth: .infinity, minHeight: 70, alignment: .leading).padding(11)
                                    .webCard(15, fill: selectedReason == item.1 ? WellPhoneStyle.lime.opacity(0.45) : .white, border: selectedReason == item.1 ? WellPhoneStyle.green : WellPhoneStyle.border)
                            }.buttonStyle(.plain)
                        }
                    }
                    Text("Or put it in your own words").font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green).padding(.top, 2)
                    TextField("What did you have in mind when you opened \(appName)?", text: $reason, axis: .vertical).lineLimit(2...4).padding(13).webCard(13)
                    Text("A short phrase is enough. This stays on your device.").font(.caption).foregroundStyle(WellPhoneStyle.muted)
                    HStack { Text("Try one of these").font(.headline); Spacer(); Button("Show other ideas") { refreshIdeas() }.font(.subheadline.weight(.semibold)).foregroundStyle(WellPhoneStyle.green) }.padding(.top, 8)
                    VStack(alignment: .leading, spacing: 13) {
                        if !savedStepsToShow.isEmpty {
                            Text("FROM YOUR SAVED STEPS").font(.caption.bold()).tracking(0.8).foregroundStyle(WellPhoneStyle.muted)
                            ForEach(savedStepsToShow) { suggestion in
                                let details = quickIdeaDetails[suggestion.step] ?? ("A small step toward your goal", "🌱")
                                ideaRow(title: suggestion.step, detail: "For \(suggestion.goal) · \(details.0)", icon: details.1, badge: "Your plan") { selectSavedStep(goal: suggestion.goal, title: suggestion.step) }
                            }
                        }
                        Text(savedStepTitle).font(.caption.bold()).tracking(0.8).foregroundStyle(WellPhoneStyle.muted).padding(.top, savedStepsToShow.isEmpty ? 0 : 5)
                        ForEach(quickIdeas, id: \.self) { title in
                            let detail = quickIdeaDetails[title] ?? ("A small change of pace", "🌱")
                            ideaRow(title: title, detail: detail.0, icon: detail.1, badge: "Quick idea")
                        }
                        if let selected { Text("A small option is ready when you are: \(selected)").font(.caption).foregroundStyle(WellPhoneStyle.green).padding(10).frame(maxWidth: .infinity, alignment: .leading).background(WellPhoneStyle.lime.opacity(0.38), in: RoundedRectangle(cornerRadius: 12)) }
                        Text("Ideas are picked from your saved steps and a rotating list of quick activities.").font(.caption).foregroundStyle(WellPhoneStyle.muted).padding(.top, 2)
                    }.padding(16).webCard(22)
                    Button { continueToApp(requireReason: true) } label: {
                        Text("Continue to app with this intention").font(.subheadline.bold()).frame(maxWidth: .infinity).padding(14).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14))
                    }
                    Button { onPlan() } label: { Text("Choose my own next step").font(.subheadline.bold()).frame(maxWidth: .infinity).padding(14).foregroundStyle(WellPhoneStyle.green).background(.clear, in: RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(WellPhoneStyle.border, lineWidth: 1)) }
                    Button("Continue to \(appName) for now") { continueToApp(requireReason: false) }.font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.muted).frame(maxWidth: .infinity).padding(.bottom, 5)
                }.padding(.horizontal, 20).padding(.bottom, 25).frame(maxWidth: 480).frame(maxWidth: .infinity)
            }.background(WellPhoneStyle.canvas).toolbar(.hidden, for: .navigationBar)
                .onAppear { refreshIdeas() }
                .sheet(isPresented: $showBreathingExercise) { QuietBreathingExerciseView() }
                .sheet(isPresented: $showAvailabilityOptions) { availabilitySheet }
                .sheet(isPresented: $showPopOutTimerSetup) { popOutTimerSetupSheet }
                .familyActivityPicker(isPresented: $showAccessAppPicker, selection: $appBlocking.selection)
                .onChange(of: appBlocking.selection) { _, _ in appBlocking.saveSelection() }
                .onChange(of: showAccessAppPicker) { wasPresented, isPresented in
                    if wasPresented && !isPresented { finishAccessAppSelection() }
                }
                .alert("Redirect", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) { Button("OK", role: .cancel) { message = nil } } message: { Text(message ?? "") }
                .overlay {
                    if let completionTask { completionPage(completionTask).transition(.opacity).zIndex(1) }
                }
                .onDisappear { stopFitnessGuidance() }
        }
    }

    private func openIdea(_ title: String) {
        selected = title
        store.logChoice(kind: "redirection", title: title, detail: quickIdeaDetails[title]?.0 ?? "Quick idea")
        if let exercise = store.fitnessExercises().first(where: { $0.title == title }) {
            let fitnessGoal = store.chosenGoals.first(where: Self.isFitnessGoal)
            beginFitnessExercise(exercise, goal: fitnessGoal)
            return
        }
        if title == "Follow a quick guided stretch", let exercise = store.fitnessExercises().first(where: { $0.category == "Mobility" }) {
            beginFitnessExercise(exercise, goal: store.chosenGoals.first(where: Self.isFitnessGoal))
            return
        }
        let wikipediaPages = [
            "https://en.wikipedia.org/wiki/Trial_of_Daniel_Sickles",
            "https://en.wikiversity.org/wiki/Being_Friends",
            "https://en.wikipedia.org/wiki/Mehran_Karimi_Nasseri",
            "https://en.wikiversity.org/wiki/Future_media_class",
            "https://en.wikipedia.org/wiki/Illusory_correlation",
            "https://en.wikipedia.org/wiki/Mental_image#In_experimental_psychology",
            "https://en.wikipedia.org/wiki/Toothcomb",
            "https://en.wikipedia.org/wiki/How_a_Mosquito_Operates",
            "https://en.wikipedia.org/wiki/Hoodwinked!",
            "https://en.wikipedia.org/wiki/List_of_pseudoscience_topics"

        ]
        let poemPages = [
            "https://www.poetryfoundation.org/poems/44263/fire-and-ice",
            "https://www.poetryfoundation.org/poems/44262/dust-of-snow",
            "https://www.poetryfoundation.org/poems/148652/nothing-gold-can-stay-5c095cc5ab679"
        ]

        let destination: String?
        switch title {
        case "Read a fun Wikipedia page": destination = wikipediaPages.randomElement()
        case "Listen to a new music release": destination = "https://www.npr.org/sections/allsongs/606254804/new-music-friday"
        case "Read a short poem": destination = poemPages.randomElement()
        case "Follow a quick guided stretch", "Get a glass of water and take three slow breaths", "Step outside for a few minutes":
            completionTask = RedirectTask(title: title, icon: quickIdeaDetails[title]?.1 ?? "🌱")
            destination = nil
        case "Try a short meditation":
            showBreathingExercise = true
            destination = nil
        default: destination = nil
        }

        if let destination, let url = URL(string: destination) {
            openURL(url)
        }
    }

    private var appIcon: String {
        switch appName {
        case "Instagram": "camera"
        case "YouTube": "play.fill"
        case "Safari": "safari.fill"
        case "Calendar": "calendar"
        case "Photos": "photo.on.rectangle"
        case "Reminders": "checklist"
        case "News": "newspaper.fill"
        default: "music.note"
        }
    }

    private var savedStepsToShow: [SavedStepSuggestion] {
        let pending = store.chosenGoals.compactMap { goal -> SavedStepSuggestion? in
            guard let step = store.smallSteps(for: goal).first(where: { !store.isSmallStepComplete(goal: goal, step: $0) }) else { return nil }
            return SavedStepSuggestion(goal: goal, step: step)
        }
        let fitness = pending.filter { Self.isFitnessGoal($0.goal) }.prefix(1)
        let nonFitness = pending.filter { !Self.isFitnessGoal($0.goal) }.prefix(2)
        return Array(fitness) + Array(nonFitness)
    }

    private var savedStepTitle: String { savedStepsToShow.isEmpty ? "POPULAR QUICK IDEAS" : "TRY SOMETHING DIFFERENT" }

    private func selectSavedStep(goal: String, title: String) {
        store.logChoice(kind: "redirection", title: title, detail: goal)
        if let exercise = store.fitnessExercises().first(where: { $0.title == title }) {
            beginFitnessExercise(exercise, goal: goal)
        } else {
            completionTask = RedirectTask(title: title, icon: "✍️", goal: goal)
        }
    }

    private func beginFitnessExercise(_ exercise: FitnessExercise, goal: String?) {
        fitnessTimerTask?.cancel()
        fitnessTimerRunning = false
        fitnessSecondsRemaining = exercise.durationMinutes * 60
        fitnessGuideStep = 0
        savedFitnessWin = nil
        fitnessAudioEnabled = false
        speechSynthesizer.stopSpeaking(at: .immediate)
        fitnessCount = goal.map { store.fitnessProgressValue(goal: $0, exercise: exercise) } ?? 0
        completionTask = RedirectTask(title: exercise.title, icon: exercise.icon, goal: goal, fitnessExercise: exercise)
    }

    private func toggleFitnessAudio(_ exercise: FitnessExercise) {
        fitnessAudioEnabled.toggle()
        if fitnessAudioEnabled { speakFitnessCue(for: exercise) }
        else { speechSynthesizer.stopSpeaking(at: .immediate) }
    }

    private func speakFitnessCue(for exercise: FitnessExercise) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let name = exercise.title.components(separatedBy: " · ").first ?? exercise.title
        let counts = (1...min(exercise.target, 12)).map(String.init).joined(separator: ", ")
        let text: String
        if name.localizedCaseInsensitiveContains("hip circles") {
            text = "Stand tall and keep the circles small and comfortable. Circle your hips clockwise slowly. \(counts). Now counter-clockwise. \(counts). Keep breathing and use a chair for balance if you like."
        } else if exercise.category == "Mobility" {
            text = "\(exercise.summary) Move slowly and comfortably. Complete up to \(exercise.target) \(exercise.unit). \(counts). Reverse sides or direction when needed. Stop if anything hurts."
        } else if exercise.category == "Strength" {
            text = "\(exercise.summary) Move with control and breathe. Work toward \(exercise.target) \(exercise.unit), resting whenever you need. Stop if anything hurts."
        } else {
            text = "\(exercise.summary) Start easy and keep a pace that feels right for you. Continue for up to \(exercise.durationMinutes) minutes, taking breaks whenever you like."
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.46
        speechSynthesizer.speak(utterance)
    }

    private func speakCurrentGuideStep(_ exercise: FitnessExercise) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: exercise.instructions[fitnessGuideStep])
        utterance.rate = 0.46
        speechSynthesizer.speak(utterance)
    }

    private func toggleFitnessTimer(_ exercise: FitnessExercise) {
        if fitnessTimerRunning {
            fitnessTimerTask?.cancel()
            fitnessTimerRunning = false
            return
        }
        if fitnessSecondsRemaining <= 0 { fitnessSecondsRemaining = exercise.durationMinutes * 60 }
        fitnessTimerRunning = true
        fitnessTimerTask = Task { @MainActor in
            while fitnessSecondsRemaining > 0 && !Task.isCancelled {
                do { try await Task.sleep(for: .seconds(1)) } catch { return }
                fitnessSecondsRemaining -= 1
            }
            fitnessTimerRunning = false
        }
    }

    private var fitnessTimerText: String {
        String(format: "%d:%02d", fitnessSecondsRemaining / 60, fitnessSecondsRemaining % 60)
    }

    private func ideaRow(title: String, detail: String, icon: String, badge: String, action: (() -> Void)? = nil) -> some View {
        Button { if let action { action() } else { openIdea(title) } } label: {
            HStack(spacing: 10) {
                Text(icon).font(.title3).frame(width: 34, height: 34).background(WellPhoneStyle.lime.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 3) { Text(title).font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.ink); Text(detail).font(.caption).foregroundStyle(WellPhoneStyle.muted) }
                Spacer(minLength: 0)
                Text(badge).font(.caption2).foregroundStyle(WellPhoneStyle.muted).padding(6).background(WellPhoneStyle.canvas, in: RoundedRectangle(cornerRadius: 7))
            }.padding(10).background(.white, in: RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(WellPhoneStyle.border, lineWidth: 1))
        }.buttonStyle(.plain)
    }

    private func refreshIdeas() {
        if store.chosenGoals.contains(where: Self.isFitnessGoal) {
            quickIdeas = Array(store.fitnessExercises().shuffled().prefix(2).map(\.title))
        } else {
            let all = Array(quickIdeaDetails.keys).shuffled()
            quickIdeas = Array(all.prefix(2))
        }
    }

    private static func isFitnessGoal(_ goal: String) -> Bool {
        ["increase fitness", "get stronger"].contains(goal.lowercased())
    }

    private func continueToApp(requireReason: Bool) {
        let selectedReasonText = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !requireReason || selectedReason != nil || !selectedReasonText.isEmpty else {
            message = "Choose a reason or write one in your own words."
            return
        }
        if requireReason {
            allowedApplicationToken = nil
            showAvailabilityOptions = true
        } else {
            let reasonText = reason.trimmingCharacters(in: .whitespacesAndNewlines)
            let intention = reasonText.isEmpty ? (selectedReason ?? "Continued for now") : reasonText
            store.logChoice(kind: "appCheckIn", title: appName, detail: intention)
            if let url = URL(string: appAddress) { openURL(url) }
        }
    }

    private var appAddress: String {
        switch appName {
        case "Instagram": "https://www.instagram.com"
        case "YouTube": "https://www.youtube.com"
        case "Safari": "https://www.wikipedia.org"
        case "Calendar": "calshow://"
        case "Photos": "photos-redirect://"
        case "Reminders": "x-apple-reminderkit://"
        case "News": "applenews://"
        default: "https://www.tiktok.com"
        }
    }

    private var availabilitySheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("How long should \(appName) be available?").font(.title2.bold())
                Text("Choose the blocked app you want to open. Select \(appName) if it appears in the list; only that app will be allowed. Other selected apps, categories, and websites stay blocked. iOS requires at least 15 minutes.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                if appBlocking.selection.applicationTokens.isEmpty {
                    Text("Select individual apps in Your plan to use one-app access windows. Category-only selections can’t be opened one app at a time.")
                        .font(.caption).foregroundStyle(.orange)
                } else {
                    Picker("App to allow", selection: $allowedApplicationToken) {
                        Text("Choose an app").tag(nil as ApplicationToken?)
                        ForEach(Array(appBlocking.selection.applicationTokens), id: \.self) { token in
                            Label(token).tag(Optional(token))
                        }
                    }.pickerStyle(.menu)
                        .padding(11).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 12))
                }
                Button {
                    applicationsBeforeAccessPicker = appBlocking.selection.applicationTokens
                    showAvailabilityOptions = false
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(350))
                        showAccessAppPicker = true
                    }
                } label: {
                    Label("Can’t find \(appName)? Choose it in Screen Time", systemImage: "plus.app")
                        .font(.subheadline.weight(.semibold)).foregroundStyle(WellPhoneStyle.green)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 5)
                }
                Picker("Minutes", selection: $availabilityMinutes) {
                    ForEach(15...24, id: \.self) { minutes in
                        Text("\(minutes) \(minutes == 1 ? "minute" : "minutes")").tag(minutes)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
                .clipped()
                .accessibilityLabel("App availability duration")
                Button {
                    if let url = popOutShortcutURL { openURL(url) }
                } label: {
                    Label("Start Pop Out Timer", systemImage: "pip")
                        .font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green)
                        .frame(maxWidth: .infinity).padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(WellPhoneStyle.border, lineWidth: 1))
                }
                Button("How to connect Pop Out Timer") { showPopOutTimerSetup = true }
                    .font(.caption.weight(.semibold)).foregroundStyle(WellPhoneStyle.muted)
                Spacer(minLength: 0)
                Button("Continue for \(availabilityMinutes) minutes") {
                    do {
                        guard let allowedApplicationToken else {
                            message = "Choose one selected app to allow during this window."
                            return
                        }
                        try appBlocking.makeAppsAvailable(for: availabilityMinutes, allowing: allowedApplicationToken)
                        let reasonText = reason.trimmingCharacters(in: .whitespacesAndNewlines)
                        let intention = reasonText.isEmpty ? (selectedReason ?? "Intentional session") : reasonText
                        store.logChoice(kind: "appCheckIn", title: appName, detail: "\(availabilityMinutes)-minute access · \(intention)")
                        showAvailabilityOptions = false
                        if let url = URL(string: appAddress) { openURL(url) }
                    } catch { message = error.localizedDescription }
                }.font(.headline).foregroundStyle(.white).frame(maxWidth: .infinity).padding(15).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14))
                    .disabled(allowedApplicationToken == nil)
                    .opacity(allowedApplicationToken == nil ? 0.55 : 1)
            }.padding(22).background(WellPhoneStyle.canvas.ignoresSafeArea())
                .navigationTitle("Temporary access").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Cancel") { showAvailabilityOptions = false } } }
        }.presentationDetents([.medium, .large])
    }

    private var popOutShortcutURL: URL? {
        var components = URLComponents()
        components.scheme = "shortcuts"
        components.host = "run-shortcut"
        components.queryItems = [
            URLQueryItem(name: "name", value: "WellPhone Access Timer"),
            URLQueryItem(name: "input", value: "text"),
            URLQueryItem(name: "text", value: "\(availabilityMinutes)")
        ]
        return components.url
    }

    private var popOutTimerSetupSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Text("Use a floating timer while you’re in another app.").font(.title3.bold())
                Text("Pop Out Timer runs its floating window using picture-in-picture. WellPhone can hand your chosen minutes to a Shortcut, but iOS doesn’t let WellPhone embed or control another app directly.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                Text("One-time setup").font(.headline).padding(.top, 4)
                Text("In Shortcuts, create a shortcut named “WellPhone Access Timer”. Add Pop Out Timer’s Configure Timer action and use Shortcut Input as its duration in minutes. Set the timer to pop out, then return to WellPhone and tap Start Pop Out Timer.").font(.subheadline)
                Link("Get Pop Out Timer", destination: URL(string: "https://apps.apple.com/us/app/pop-out-timer-stopwatch-clock/id1352722326")!)
                    .font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green)
                Spacer()
            }.padding(22).background(WellPhoneStyle.canvas.ignoresSafeArea())
                .navigationTitle("Floating timer").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { showPopOutTimerSetup = false } } }
        }.presentationDetents([.medium, .large])
    }

    private func completionPage(_ task: RedirectTask) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            AppHeader(onPlan: onPlan).padding(.top, 8)
            Button { stopFitnessGuidance(); completionTask = nil } label: { Label("Back to choices", systemImage: "arrow.left").font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green) }.buttonStyle(.plain).padding(.top, 14)
            Text("A LITTLE TIME FOR YOU").font(.caption.bold()).tracking(1.5).foregroundStyle(WellPhoneStyle.muted).padding(.top, 5)
            Text(task.title).font(.system(size: 28, weight: .bold, design: .rounded)).tracking(-0.8)
            Text("Small steps count. Take the time you need.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
            Spacer().frame(height: 6)
            if let exercise = task.fitnessExercise {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(exercise.category.uppercased()).font(.caption.bold()).tracking(1).foregroundStyle(WellPhoneStyle.green)
                        Spacer()
                        Button { toggleFitnessAudio(exercise) } label: {
                            Label(fitnessAudioEnabled ? "Audio on" : "Audio off", systemImage: fitnessAudioEnabled ? "speaker.wave.2.fill" : "speaker.slash")
                                .font(.caption.bold()).foregroundStyle(WellPhoneStyle.green)
                        }.buttonStyle(.plain).accessibilityLabel(fitnessAudioEnabled ? "Turn spoken guidance off" : "Turn spoken guidance on")
                    }
                    HStack(spacing: 12) {
                        Image(systemName: "timer").font(.title3).foregroundStyle(WellPhoneStyle.green)
                        Text(fitnessTimerText).font(.system(.title2, design: .rounded).weight(.bold)).monospacedDigit()
                        Text("of \(exercise.durationMinutes) min").font(.caption).foregroundStyle(WellPhoneStyle.muted)
                        Spacer()
                        Button { toggleFitnessTimer(exercise) } label: {
                            Label(fitnessTimerRunning ? "Pause" : (fitnessSecondsRemaining < exercise.durationMinutes * 60 ? "Resume" : "Start"), systemImage: fitnessTimerRunning ? "pause.fill" : "play.fill")
                                .font(.caption.bold()).padding(.horizontal, 12).padding(.vertical, 9).foregroundStyle(.white).background(WellPhoneStyle.green, in: Capsule())
                        }.buttonStyle(.plain)
                    }.padding(11).background(WellPhoneStyle.canvas, in: RoundedRectangle(cornerRadius: 13))
                    Text("STEP \(fitnessGuideStep + 1) OF \(exercise.instructions.count)").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
                    Text(exercise.instructions[fitnessGuideStep]).font(.body).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, minHeight: 78, alignment: .leading)
                    HStack {
                        Button { fitnessGuideStep = max(0, fitnessGuideStep - 1); if fitnessAudioEnabled { speakCurrentGuideStep(exercise) } } label: { Label("Back", systemImage: "chevron.left") }.disabled(fitnessGuideStep == 0)
                        Spacer()
                        Button { fitnessGuideStep = min(exercise.instructions.count - 1, fitnessGuideStep + 1); if fitnessAudioEnabled { speakCurrentGuideStep(exercise) } } label: { Label("Next", systemImage: "chevron.right") }.disabled(fitnessGuideStep == exercise.instructions.count - 1)
                    }.font(.subheadline.bold()).tint(WellPhoneStyle.green)
                    Divider()
                    Stepper(value: $fitnessCount, in: 1...exercise.target) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Your progress: \(fitnessCount) \(exercise.unit)").font(.subheadline.bold())
                            Text("Goal: \(exercise.target) \(exercise.unit). A smaller amount counts too.").font(.caption).foregroundStyle(WellPhoneStyle.muted)
                        }
                    }.tint(WellPhoneStyle.green)
                }.padding(16).frame(maxWidth: .infinity, alignment: .leading).background(.white, in: RoundedRectangle(cornerRadius: 20)).overlay(RoundedRectangle(cornerRadius: 20).stroke(WellPhoneStyle.border, lineWidth: 1))
                if let savedFitnessWin {
                    HStack(spacing: 10) { Text("🌱"); Text(savedFitnessWin).font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green) }.padding(13).frame(maxWidth: .infinity, alignment: .leading).background(WellPhoneStyle.lime.opacity(0.48), in: RoundedRectangle(cornerRadius: 15))
                    Button("Done for now") { stopFitnessGuidance(); completionTask = nil; tab = 0 }.font(.headline).frame(maxWidth: .infinity).padding(14).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14))
                } else {
                    Button { saveFitnessWin(exercise, goal: task.goal) } label: { Text("Save my progress  ✓").font(.headline).frame(maxWidth: .infinity).padding(14).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14)) }
                }
            } else {
                VStack(spacing: 8) {
                    Text(task.icon).font(.system(size: 42))
                    Text("Your next step is ready").font(.headline)
                    Text(task.goal.map { "For \($0)" } ?? "A quick idea for this moment").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                }.frame(maxWidth: .infinity, minHeight: 142).background(.white, in: RoundedRectangle(cornerRadius: 20)).overlay(RoundedRectangle(cornerRadius: 20).stroke(WellPhoneStyle.border, lineWidth: 1))
                Button {
                    if let goal = task.goal { store.toggleSmallStep(goal: goal, step: task.title) }
                    completionTask = nil
                    tab = 0
                } label: { Text("I did this  ✓").font(.headline).frame(maxWidth: .infinity).padding(14).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14)) }
            }
            Button("Choose something else") { stopFitnessGuidance(); completionTask = nil }.font(.headline).frame(maxWidth: .infinity).padding(14).foregroundStyle(WellPhoneStyle.green).overlay(RoundedRectangle(cornerRadius: 14).stroke(WellPhoneStyle.border, lineWidth: 1))
            HStack(spacing: 12) { Text("🌱"); Text(task.fitnessExercise == nil ? "This time belongs to you. There’s no score and nothing to earn." : "Move at your pace. Rest as needed, and stop if you feel pain or unwell.").font(.subheadline).foregroundStyle(WellPhoneStyle.green) }.padding(14).frame(maxWidth: .infinity, alignment: .leading).background(WellPhoneStyle.lime.opacity(0.45), in: RoundedRectangle(cornerRadius: 16))
            Spacer(minLength: 0)
        }.padding(.horizontal, 20).frame(maxWidth: 480).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).background(WellPhoneStyle.canvas.ignoresSafeArea())
    }

    private func stopFitnessGuidance() {
        fitnessTimerTask?.cancel()
        fitnessTimerRunning = false
        fitnessAudioEnabled = false
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    private func saveFitnessWin(_ exercise: FitnessExercise, goal: String?) {
        let amount = min(fitnessCount, exercise.target)
        store.recordFitnessProgress(goal: goal, exercise: exercise, value: amount)
        let detail = "\(amount) of \(exercise.target) \(exercise.unit) · \(exercise.category)"
        store.logChoice(kind: "fitnessProgress", title: exercise.title, detail: detail)
        if amount == exercise.target {
            savedFitnessWin = "You reached your goal: \(detail). Nice work."
        } else {
            savedFitnessWin = "You did \(detail). That’s a real win; it counts."
        }
    }

    private func finishAccessAppSelection() {
        let newlySelected = appBlocking.selection.applicationTokens.subtracting(applicationsBeforeAccessPicker)
        appBlocking.saveSelection()
        allowedApplicationToken = newlySelected.count == 1 ? newlySelected.first : nil
        showAvailabilityOptions = true
    }
}

private struct SavedStepSuggestion: Identifiable {
    var goal: String
    var step: String
    var id: String { "\(goal)|\(step)" }
}

private struct RedirectTask {
    var title: String
    var icon: String
    var goal: String? = nil
    var fitnessExercise: FitnessExercise? = nil
}

private struct QuietBreathingExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phase = "Ready"
    @State private var circleScale = 0.72
    @State private var isComplete = false

    var body: some View {
        VStack(spacing: 26) {
            HStack {
                Text("A quiet pause").font(.headline)
                Spacer()
                Button("Done") { dismiss() }.font(.subheadline.weight(.semibold))
            }
            Spacer()
            Circle()
                .fill(WellPhoneStyle.lime.opacity(0.8))
                .frame(width: 190, height: 190)
                .overlay(Circle().stroke(WellPhoneStyle.green.opacity(0.2), lineWidth: 1))
                .scaleEffect(circleScale)
                .overlay(Text(isComplete ? "Complete" : phase).font(.title3.weight(.semibold)).foregroundStyle(WellPhoneStyle.ink))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(isComplete ? "Breathing exercise complete" : phase)
            Text(isComplete ? "Take this calm with you." : "Follow the circle. This exercise is silent.")
                .font(.subheadline).foregroundStyle(WellPhoneStyle.muted).multilineTextAlignment(.center)
            Spacer()
        }
        .padding(24)
        .background(WellPhoneStyle.canvas.ignoresSafeArea())
        .task { await runExercise() }
    }

    @MainActor
    private func runExercise() async {
        for _ in 0..<3 {
            guard !Task.isCancelled else { return }
            phase = "Breathe in"
            withAnimation(.easeInOut(duration: 4)) { circleScale = 1.0 }
            do { try await Task.sleep(for: .seconds(4)) } catch { return }

            phase = "Pause"
            do { try await Task.sleep(for: .seconds(2)) } catch { return }

            phase = "Breathe out"
            withAnimation(.easeInOut(duration: 6)) { circleScale = 0.72 }
            do { try await Task.sleep(for: .seconds(6)) } catch { return }
        }
        phase = ""
        isComplete = true
    }
}

struct InsightsView: View {
    @EnvironmentObject private var store: WellPhoneStore
    var onPlan: () -> Void = {}
    @State private var showClearChoicesConfirmation = false
    @State private var showClearAllConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    AppHeader(onPlan: onPlan).padding(.top, 8)
                    Text("YOUR WEEK, YOUR WAY").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted).padding(.top, 10)
                    Text("Attention with intention.").font(.system(size: 29, weight: .bold, design: .rounded)).tracking(-1)
                    Text("A private record of the choices you make in WellPhone.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                    HStack(spacing: 10) {
                        activitySummary(title: "REDIRECTIONS", count: store.activityChoices.filter { $0.kind == "redirection" }.count, caption: "small steps you chose")
                        activitySummary(title: "APP CHECK-INS", count: store.activityChoices.filter { $0.kind == "appCheckIn" }.count, caption: "intentional or continued")
                    }
                    Text("Recent choices").font(.headline).padding(.top, 3)
                    if store.activityChoices.isEmpty {
                        Text("Your redirections and app check-ins will appear here.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted).frame(maxWidth: .infinity, alignment: .leading).padding(18).webCard(20)
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(store.activityChoices.prefix(12))) { choice in
                                HStack(alignment: .top, spacing: 11) {
                                    Text(choice.kind == "appCheckIn" ? "📱" : "🌱").font(.title3).frame(width: 30)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(choice.title).font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.ink)
                                        Text(choice.detail).font(.caption).foregroundStyle(WellPhoneStyle.muted)
                                    }
                                    Spacer(minLength: 5)
                                    Text(choice.date.formatted(date: .abbreviated, time: .omitted)).font(.caption2).foregroundStyle(WellPhoneStyle.muted)
                                }.padding(.vertical, 12)
                                if choice.id != store.activityChoices.prefix(12).last?.id { Divider().padding(.leading, 41) }
                            }
                        }.padding(.horizontal, 14).webCard(20)
                    }
                    Text("Goal reflections").font(.headline).padding(.top, 5)
                    if store.reflections.isEmpty {
                        Text("Your evening goal reflections will show up here.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted).frame(maxWidth: .infinity).padding(24).webCard(22)
                    } else {
                        ForEach(store.reflections.values.sorted { $0.date > $1.date }) { reflection in
                            VStack(alignment: .leading, spacing: 9) {
                                Text(dateTitle(reflection.date)).font(.caption2.bold()).tracking(0.8).foregroundStyle(WellPhoneStyle.muted)
                                ForEach(Array(reflection.goals.enumerated()), id: \.offset) { index, goal in
                                    HStack(alignment: .firstTextBaseline) { Text(goal).font(.subheadline); Spacer(); Text(statusTitle(reflection.statuses.indices.contains(index) ? reflection.statuses[index] : "")).font(.caption.bold()).foregroundStyle(WellPhoneStyle.green) }.padding(.top, 8)
                                    if index < reflection.goals.count - 1 { Divider() }
                                }
                            }.padding(15).frame(maxWidth: .infinity, alignment: .leading).webCard(22)
                        }
                    }
                    Text("Your activity is saved on this device. WellPhone does not make a diagnosis or judge your choices.").font(.caption).foregroundStyle(WellPhoneStyle.muted).padding(13).background(WellPhoneStyle.lime.opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Privacy & data").font(.headline)
                        Text("Your records stay on this device. Clear recent choices alone, or remove all activity history and routine progress.").font(.caption).foregroundStyle(WellPhoneStyle.muted)
                        Button("Clear recent choices") { showClearChoicesConfirmation = true }
                            .font(.subheadline.weight(.semibold)).foregroundStyle(WellPhoneStyle.green)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(12)
                            .background(.white, in: RoundedRectangle(cornerRadius: 12))
                        Button("Clear all local activity") { showClearAllConfirmation = true }
                            .font(.subheadline.weight(.semibold)).foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading).padding(12)
                            .background(.white, in: RoundedRectangle(cornerRadius: 12))
                    }.padding(15).webCard(20)
                }.padding(.horizontal, 20).padding(.bottom, 28).frame(maxWidth: 480).frame(maxWidth: .infinity)
            }.background(WellPhoneStyle.canvas).toolbar(.hidden, for: .navigationBar)
                .confirmationDialog("Clear recent choices?", isPresented: $showClearChoicesConfirmation, titleVisibility: .visible) {
                    Button("Clear recent choices", role: .destructive) { store.clearRecentChoices() }
                    Button("Cancel", role: .cancel) { }
                } message: { Text("This removes the recent redirection and app check-in list. Other activity remains saved.") }
                .confirmationDialog("Clear all local activity?", isPresented: $showClearAllConfirmation, titleVisibility: .visible) {
                    Button("Clear all local activity", role: .destructive) { store.clearAllLocalActivity() }
                    Button("Cancel", role: .cancel) { }
                } message: { Text("This removes recent choices, goal reflections, daily goals, routine progress, and completed plan steps. Your selected long-term goals and app blocking settings remain.") }
        }
    }

    private func activitySummary(title: String, count: Int, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.caption.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
            Text("\(count)").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(WellPhoneStyle.ink)
            Text(caption).font(.caption).foregroundStyle(WellPhoneStyle.muted)
        }.frame(maxWidth: .infinity, minHeight: 112, alignment: .leading).padding(15).webCard(20)
    }

    private func dateTitle(_ key: String) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: key) else { return key }
        return date.formatted(date: .abbreviated, time: .omitted).uppercased()
    }
    private func statusTitle(_ status: String) -> String {
        switch status { case "met": "Met"; case "in-progress": "In progress"; case "not-today": "Not today"; default: "Reflected" }
    }
}

struct BrandMark: View {
    var body: some View {
        HStack(spacing: 9) {
            Text("w").font(.system(size: 19, weight: .bold, design: .rounded)).foregroundStyle(.white).frame(width: 31, height: 31).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 11))
            Text("wellphone").font(.headline.weight(.bold)).tracking(-0.7).foregroundStyle(WellPhoneStyle.ink)
        }
    }
}

struct AppHeader: View {
    var onPlan: () -> Void

    var body: some View {
        HStack {
            BrandMark()
            Spacer()
            Button("Your plan", action: onPlan)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(WellPhoneStyle.green.opacity(0.82))
        }
        .frame(height: 42)
        .accessibilityElement(children: .contain)
    }
}

private struct PlanSettingsSheet: View {
    @EnvironmentObject private var store: WellPhoneStore
    @EnvironmentObject private var appBlocking: AppBlockingStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGoals: Set<String> = []
    @State private var fitnessLevel: FitnessLevel = .beginner
    @State private var newGoal = ""
    @State private var showAppPicker = false
    @State private var message: String?

    private let suggestions = [
        "Do Better Academically", "Get Job", "Better Sleep", "Increase Fitness",
        "Improve my Home", "Learn a Creative Skill", "Write a Book", "Read more"
    ]

    private var selectedShieldCount: Int {
        appBlocking.selection.applicationTokens.count + appBlocking.selection.categoryTokens.count + appBlocking.selection.webDomainTokens.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("YOUR PLAN").font(.caption2.bold()).tracking(1.2).foregroundStyle(WellPhoneStyle.muted).padding(.top, 12)
                    Text("Make it yours.").font(.system(size: 30, weight: .bold, design: .rounded)).tracking(-1)
                    Text("Choose the goals you want WellPhone to keep in view. Your changes stay on this device.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                        ForEach(suggestions, id: \.self) { goal in
                            let isSelected = selectedGoals.contains(goal)
                            Button { toggle(goal) } label: {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle").foregroundStyle(isSelected ? WellPhoneStyle.green : WellPhoneStyle.muted)
                                    Text(goal).font(.subheadline.weight(.medium)).foregroundStyle(WellPhoneStyle.ink).multilineTextAlignment(.leading)
                                    Spacer(minLength: 0)
                                }.frame(maxWidth: .infinity, minHeight: 56, alignment: .leading).padding(11)
                                    .webCard(15, fill: isSelected ? WellPhoneStyle.lime.opacity(0.4) : .white, border: isSelected ? WellPhoneStyle.green : WellPhoneStyle.border)
                            }.buttonStyle(.plain)
                        }
                    }
                    if selectedGoals.contains(where: Self.isFitnessGoal) { FitnessLevelPicker(selection: $fitnessLevel) }
                    HStack(spacing: 8) {
                        TextField("Add your own goal", text: $newGoal).padding(12).webCard(13)
                        Button("Add") { addGoal() }.font(.subheadline.bold()).foregroundStyle(WellPhoneStyle.green)
                    }
                    if !selectedGoals.isEmpty {
                        VStack(alignment: .leading, spacing: 11) {
                            Text("YOUR GOALS").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
                            ForEach(Array(selectedGoals).sorted(), id: \.self) { goal in
                                let steps = store.smallSteps(for: goal)
                                HStack(spacing: 9) {
                                    Image(systemName: "leaf.fill").foregroundStyle(WellPhoneStyle.green)
                                    VStack(alignment: .leading, spacing: 2) { Text(goal).font(.subheadline.bold()); Text("\(steps.count) small steps ready").font(.caption).foregroundStyle(WellPhoneStyle.muted) }
                                    Spacer()
                                    Button { selectedGoals.remove(goal) } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(WellPhoneStyle.muted) }
                                }
                            }
                        }.padding(15).webCard(20)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("APP SHIELDS").font(.caption2.bold()).tracking(1).foregroundStyle(WellPhoneStyle.muted)
                        Text("Choose apps, website domains, or categories for an iOS Screen Time shield. Website domains stay blocked during app access windows; select apps individually to allow one app temporarily.").font(.subheadline).foregroundStyle(WellPhoneStyle.muted)
                        Button {
                            Task {
                                do {
                                    if try await appBlocking.authorize() { showAppPicker = true }
                                    else { message = "Screen Time access wasn’t approved. You can allow it in Settings and try again." }
                                } catch { message = "Screen Time access wasn’t approved. You can try again here." }
                            }
                        } label: {
                            Label(selectedShieldCount == 0 ? "Choose apps and websites to shield" : "Edit shielded apps and websites", systemImage: "hand.raised.fill")
                                .font(.subheadline.bold()).frame(maxWidth: .infinity).padding(13).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14))
                        }
                        if selectedShieldCount > 0 {
                            VStack(alignment: .leading, spacing: 4) {
                                if !appBlocking.selection.applicationTokens.isEmpty {
                                    Text("\(appBlocking.selection.applicationTokens.count) app(s) selected").font(.caption)
                                }
                                if !appBlocking.selection.webDomainTokens.isEmpty {
                                    Text("\(appBlocking.selection.webDomainTokens.count) website(s) selected").font(.caption)
                                }
                                if !appBlocking.selection.categoryTokens.isEmpty {
                                    Text("\(appBlocking.selection.categoryTokens.count) app or web category(s) selected").font(.caption)
                                }
                            }.foregroundStyle(WellPhoneStyle.muted)
                        }
                    }.padding(15).webCard(20)
                    Button { saveAndDismiss() } label: {
                        Text("Save my plan").font(.subheadline.bold()).frame(maxWidth: .infinity).padding(14).foregroundStyle(.white).background(WellPhoneStyle.green, in: RoundedRectangle(cornerRadius: 14))
                    }
                }.padding(.horizontal, 20).padding(.bottom, 28).frame(maxWidth: 480).frame(maxWidth: .infinity)
            }.background(WellPhoneStyle.canvas)
                .navigationTitle("Your plan").navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { saveAndDismiss() }.foregroundStyle(WellPhoneStyle.green) } }
                .familyActivityPicker(isPresented: $showAppPicker, selection: $appBlocking.selection)
                .onAppear { selectedGoals = Set(store.chosenGoals); fitnessLevel = store.fitnessLevel; appBlocking.refreshAuthorization() }
                .onChange(of: appBlocking.selection) { _, _ in appBlocking.saveSelection() }
                .alert("Screen Time", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) { Button("OK", role: .cancel) { message = nil } } message: { Text(message ?? "") }
        }.presentationDetents([.large])
    }

    private static func isFitnessGoal(_ goal: String) -> Bool { ["increase fitness", "get stronger"].contains(goal.lowercased()) }

    private func toggle(_ goal: String) {
        if selectedGoals.contains(goal) { selectedGoals.remove(goal) } else { selectedGoals.insert(goal) }
    }

    private func addGoal() {
        let goal = newGoal.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !goal.isEmpty else { return }
        selectedGoals.insert(goal)
        newGoal = ""
    }

    private func saveAndDismiss() {
        store.updateChosenGoals(Array(selectedGoals).sorted())
        store.updateFitnessLevel(fitnessLevel)
        dismiss()
    }
}

private extension View {
    func webCard(_ radius: CGFloat = 22, fill: Color = .white, border: Color = WellPhoneStyle.border) -> some View {
        background(fill, in: RoundedRectangle(cornerRadius: radius))
            .overlay(RoundedRectangle(cornerRadius: radius).stroke(border, lineWidth: 1))
            .shadow(color: WellPhoneStyle.ink.opacity(0.035), radius: 10, x: 0, y: 4)
    }
}
