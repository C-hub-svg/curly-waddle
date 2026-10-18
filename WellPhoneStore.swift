import Foundation
import SwiftUI

struct GoalReflection: Codable, Identifiable {
    var id: String { date }
    var date: String
    var goals: [String]
    var statuses: [String]
}

struct RoutineRecord: Codable {
    var index: Int = 0
    var completed: [Int] = []
    var skipped: [Int] = []

    private enum CodingKeys: String, CodingKey { case index, completed, skipped }

    init(index: Int = 0, completed: [Int] = [], skipped: [Int] = []) {
        self.index = index
        self.completed = completed
        self.skipped = skipped
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        index = try values.decodeIfPresent(Int.self, forKey: .index) ?? 0
        completed = try values.decodeIfPresent([Int].self, forKey: .completed) ?? []
        skipped = try values.decodeIfPresent([Int].self, forKey: .skipped) ?? []
    }
}

struct ActivityChoice: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date = .now
    var kind: String
    var title: String
    var detail: String
}

enum FitnessLevel: String, CaseIterable, Identifiable, Codable {
    case beginner, intermediate, advanced, elite
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var description: String {
        switch self {
        case .beginner: "I’m building a regular movement habit."
        case .intermediate: "I exercise regularly and know the basics."
        case .advanced: "I train consistently and want a challenge."
        case .elite: "I’m highly experienced with structured training."
        }
    }
}

struct FitnessExercise: Identifiable {
    var id: String { title }
    var title: String
    var category: String
    var durationMinutes: Int
    var target: Int
    var unit: String
    var summary: String
    var instructions: [String]
    var level: FitnessLevel

    var icon: String {
        switch category {
        case "Mobility": "🧘"
        case "Strength": "💪"
        default: "🚶"
        }
    }

    private struct Spec {
        var title: String; var category: String; var minutes: Int; var target: Int; var unit: String; var summary: String
    }

    static func forLevel(_ level: FitnessLevel) -> [FitnessExercise] {
        let specs: [Spec]
        switch level {
        case .beginner:
            specs = [
                .init(title:"Wrist circles",category:"Mobility",minutes:1,target:10,unit:"circles each way",summary:"Loosen your wrists gently."), .init(title:"Shoulder circles",category:"Mobility",minutes:2,target:10,unit:"circles each way",summary:"Ease tension around your shoulders."), .init(title:"Seated trunk turns",category:"Mobility",minutes:4,target:6,unit:"turns per side",summary:"Practice easy, supported rotation."), .init(title:"Ankle rocks",category:"Mobility",minutes:5,target:8,unit:"rocks per side",summary:"Gently move your ankles with support."), .init(title:"Wall calf stretch",category:"Mobility",minutes:3,target:20,unit:"seconds per side",summary:"Stretch your calves in a supported stance."),
                .init(title:"Wall push-ups",category:"Strength",minutes:3,target:10,unit:"reps",summary:"Build pushing strength using a wall."), .init(title:"Chair sit-to-stands",category:"Strength",minutes:5,target:8,unit:"reps",summary:"Practice standing and sitting with control."), .init(title:"Glute bridges",category:"Strength",minutes:5,target:8,unit:"reps",summary:"Strengthen hips with a floor-based option."), .init(title:"Bird-dogs",category:"Strength",minutes:6,target:5,unit:"reps per side",summary:"Practice steady trunk and hip movement."), .init(title:"Countertop heel raises",category:"Strength",minutes:4,target:10,unit:"reps",summary:"Strengthen your calves while holding support."),
                .init(title:"Easy march",category:"Endurance & cardio",minutes:3,target:3,unit:"minutes",summary:"A low-impact way to get moving."), .init(title:"Step-touches",category:"Endurance & cardio",minutes:5,target:5,unit:"minutes",summary:"Step gently side to side."), .init(title:"Relaxed walk",category:"Endurance & cardio",minutes:8,target:8,unit:"minutes",summary:"Walk at a comfortable, conversational pace."), .init(title:"Comfortable walk",category:"Endurance & cardio",minutes:12,target:12,unit:"minutes",summary:"Take a slightly longer easy walk."), .init(title:"Gentle dance or walk",category:"Endurance & cardio",minutes:15,target:15,unit:"minutes",summary:"Choose music or a walk and move comfortably.")
            ]
        case .intermediate:
            specs = [
                .init(title:"Standing hip circles",category:"Mobility",minutes:3,target:8,unit:"circles each way",summary:"Explore a comfortable range at your hips."), .init(title:"Lunge and reach flow",category:"Mobility",minutes:5,target:4,unit:"flows per side",summary:"Link a supported lunge with gentle rotation."), .init(title:"Cat-cow flow",category:"Mobility",minutes:4,target:8,unit:"cycles",summary:"Move your spine smoothly on hands and knees."), .init(title:"Deep squat hold with support",category:"Mobility",minutes:3,target:20,unit:"seconds",summary:"Use a doorframe or counter to explore a squat."), .init(title:"Thoracic open books",category:"Mobility",minutes:5,target:8,unit:"reps per side",summary:"Rotate your upper back from a side-lying position."),
                .init(title:"Incline push-ups",category:"Strength",minutes:5,target:12,unit:"reps",summary:"Push from a sturdy counter or bench."), .init(title:"Reverse lunges",category:"Strength",minutes:6,target:8,unit:"reps per side",summary:"Build leg strength with controlled steps back."), .init(title:"Hip-hinge good mornings",category:"Strength",minutes:4,target:12,unit:"reps",summary:"Practice a bodyweight hip hinge."), .init(title:"Dead bugs",category:"Strength",minutes:5,target:8,unit:"reps per side",summary:"Brace gently while moving opposite limbs."), .init(title:"Side-plank knee holds",category:"Strength",minutes:4,target:20,unit:"seconds per side",summary:"Build side-body strength from a modified plank."),
                .init(title:"Brisk walk intervals",category:"Endurance & cardio",minutes:10,target:10,unit:"minutes",summary:"Alternate brisk and easy walking."), .init(title:"Low-impact step jacks",category:"Endurance & cardio",minutes:6,target:6,unit:"minutes",summary:"Raise your heart rate without jumping."), .init(title:"Stair climbs",category:"Endurance & cardio",minutes:8,target:8,unit:"minutes",summary:"Use a safe staircase at a steady pace."), .init(title:"Dance intervals",category:"Endurance & cardio",minutes:12,target:12,unit:"minutes",summary:"Alternate energetic and relaxed song sections."), .init(title:"Steady outdoor walk",category:"Endurance & cardio",minutes:15,target:15,unit:"minutes",summary:"Keep a purposeful pace while staying in control.")
            ]
        case .advanced:
            specs = [
                .init(title:"Dynamic hip-flexor flow",category:"Mobility",minutes:5,target:8,unit:"flows per side",summary:"Move through a controlled half-kneeling hip flow."), .init(title:"Cossack squat shifts",category:"Mobility",minutes:5,target:6,unit:"shifts per side",summary:"Shift side to side through a comfortable range."), .init(title:"Lunge rotation flow",category:"Mobility",minutes:6,target:6,unit:"flows per side",summary:"Combine a lunge, rotation, and hamstring shift."), .init(title:"Down-dog pedal flow",category:"Mobility",minutes:4,target:10,unit:"pedals per side",summary:"Pedal your heels gently from a supported inverted V."), .init(title:"Single-leg hinge reach",category:"Mobility",minutes:5,target:8,unit:"reaches per side",summary:"Practice balance and hip mobility together."),
                .init(title:"Tempo push-ups",category:"Strength",minutes:6,target:10,unit:"reps",summary:"Lower with control and press up smoothly."), .init(title:"Split squats",category:"Strength",minutes:7,target:10,unit:"reps per side",summary:"Strengthen each leg with a stable split stance."), .init(title:"Single-leg glute bridges",category:"Strength",minutes:6,target:10,unit:"reps per side",summary:"Use a controlled one-leg bridge variation."), .init(title:"Plank shoulder taps",category:"Strength",minutes:5,target:16,unit:"taps total",summary:"Hold a steady plank while alternating taps."), .init(title:"Pike push-ups",category:"Strength",minutes:7,target:8,unit:"reps",summary:"Challenge your shoulders with a pike position."),
                .init(title:"Run-walk tempo intervals",category:"Endurance & cardio",minutes:15,target:15,unit:"minutes",summary:"Alternate comfortably hard and easy running."), .init(title:"Fast step-up intervals",category:"Endurance & cardio",minutes:10,target:10,unit:"minutes",summary:"Use a low, stable step with controlled speed."), .init(title:"Shadow-boxing rounds",category:"Endurance & cardio",minutes:12,target:12,unit:"minutes",summary:"Move lightly through short boxing rounds."), .init(title:"Jump-rope rounds",category:"Endurance & cardio",minutes:8,target:8,unit:"minutes",summary:"Use small, soft hops or step over an imaginary rope."), .init(title:"Hill-walk repeats",category:"Endurance & cardio",minutes:15,target:15,unit:"minutes",summary:"Walk a gentle hill, recovering on the way down.")
            ]
        case .elite:
            specs = [
                .init(title:"Loaded squat pry",category:"Mobility",minutes:5,target:8,unit:"breaths",summary:"Use a very light load only if familiar and controlled."), .init(title:"90/90 hip switches",category:"Mobility",minutes:5,target:10,unit:"switches",summary:"Transition between hip rotations with control."), .init(title:"Thoracic bridge rotations",category:"Mobility",minutes:6,target:6,unit:"reps per side",summary:"Rotate from a stable bridge stance within range."), .init(title:"Hamstring floss and hinge",category:"Mobility",minutes:4,target:10,unit:"reps per side",summary:"Alternate a gentle hamstring stretch and release."), .init(title:"Deep lunge rotation flow",category:"Mobility",minutes:6,target:8,unit:"flows per side",summary:"Move fluidly through a lunge and upper-back rotation."),
                .init(title:"Archer push-ups",category:"Strength",minutes:7,target:6,unit:"reps per side",summary:"Use a wide, challenging push-up with one-arm emphasis."), .init(title:"Pistol squat to target",category:"Strength",minutes:8,target:5,unit:"reps per side",summary:"Use a box or chair to scale single-leg squats."), .init(title:"Explosive push-ups",category:"Strength",minutes:5,target:6,unit:"reps",summary:"Only add a small push-off if landings stay controlled."), .init(title:"Single-leg hip hinge",category:"Strength",minutes:6,target:8,unit:"reps per side",summary:"Balance and hinge with a long, steady spine."), .init(title:"Hollow-body hold",category:"Strength",minutes:5,target:30,unit:"seconds",summary:"Hold a compact trunk position; bend knees to scale."),
                .init(title:"Sprint-float intervals",category:"Endurance & cardio",minutes:12,target:12,unit:"minutes",summary:"Alternate short fast efforts with easy recovery."), .init(title:"Burpee intervals",category:"Endurance & cardio",minutes:8,target:8,unit:"minutes",summary:"Choose a step-back version or omit the push-up as needed."), .init(title:"Fast cycling intervals",category:"Endurance & cardio",minutes:15,target:15,unit:"minutes",summary:"Alternate hard but controlled cycling with easy spins."), .init(title:"Shuttle-run intervals",category:"Endurance & cardio",minutes:10,target:10,unit:"minutes",summary:"Use short, clear distances and controlled turns."), .init(title:"Mountain-climber intervals",category:"Endurance & cardio",minutes:6,target:6,unit:"minutes",summary:"Alternate quick controlled efforts with recovery.")
            ]
        }
        return specs.map { spec in
            FitnessExercise(title: "\(spec.minutes)-minute \(spec.title.lowercased()) · \(spec.target) \(spec.unit)", category: spec.category, durationMinutes: spec.minutes, target: spec.target, unit: spec.unit, summary: spec.summary, instructions: instructions(for: spec), level: level)
        }
    }

    private static func instructions(for spec: Spec) -> [String] {
        switch spec.category {
        case "Mobility": ["Find a clear, comfortable space. Use a wall or chair for balance if helpful.", "Begin with a small, easy range and move slowly through \(spec.title.lowercased()).", "Continue for up to \(spec.target) \(spec.unit). Breathe normally and never force a stretch.", "Pause or make the movement smaller if anything feels uncomfortable."]
        case "Strength": ["Set up a stable surface and use the easiest variation that feels controlled.", "Try a few slow practice repetitions of \(spec.title.lowercased()) before continuing.", "Work toward \(spec.target) \(spec.unit), resting whenever needed. Keep each repetition smooth.", "Stop if you feel pain, dizziness, or unwell; fewer repetitions still count."]
        default: ["Choose a clear, safe route or space and keep water nearby.", "Start easily with \(spec.title.lowercased()) and build pace gradually.", "Continue for up to \(spec.target) \(spec.unit), using recoveries or pauses whenever needed.", "Keep the effort appropriate for you; stop if you feel pain, dizzy, or unwell."]
        }
    }

    static let beginner = forLevel(.beginner)
}

@MainActor
final class WellPhoneStore: ObservableObject {
    @Published var hasOnboarded: Bool
    @Published var chosenGoals: [String]
    @Published var dailyGoals: [String: [String]]
    @Published var reflections: [String: GoalReflection]
    @Published var routineRecords: [String: RoutineRecord]
    @Published var completedSmallSteps: Set<String>
    @Published var activityChoices: [ActivityChoice]
    @Published var fitnessProgress: [String: Int]
    @Published var fitnessLevel: FitnessLevel

    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        hasOnboarded = defaults.bool(forKey: "wellphone.onboarded")
        chosenGoals = Self.read([String].self, key: "wellphone.chosenGoals") ?? []
        dailyGoals = Self.read([String: [String]].self, key: "wellphone.dailyGoals") ?? [:]
        reflections = Self.read([String: GoalReflection].self, key: "wellphone.reflections") ?? [:]
        routineRecords = Self.read([String: RoutineRecord].self, key: "wellphone.routineRecords") ?? [:]
        completedSmallSteps = Set(Self.read([String].self, key: "wellphone.completedSmallSteps") ?? [])
        activityChoices = Self.read([ActivityChoice].self, key: "wellphone.activityChoices") ?? []
        fitnessProgress = Self.read([String: Int].self, key: "wellphone.fitnessProgress") ?? [:]
        fitnessLevel = Self.read(FitnessLevel.self, key: "wellphone.fitnessLevel") ?? .beginner
    }

    private static func read<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func write<T: Encodable>(_ value: T, key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    func finishOnboarding(goals: [String], fitnessLevel: FitnessLevel = .beginner) {
        self.fitnessLevel = fitnessLevel
        write(fitnessLevel, key: "wellphone.fitnessLevel")
        chosenGoals = goals
        hasOnboarded = true
        write(goals, key: "wellphone.chosenGoals")
        defaults.set(true, forKey: "wellphone.onboarded")
    }

    func updateFitnessLevel(_ level: FitnessLevel) {
        fitnessLevel = level
        write(level, key: "wellphone.fitnessLevel")
    }

    func fitnessExercises(for level: FitnessLevel? = nil) -> [FitnessExercise] {
        FitnessExercise.forLevel(level ?? fitnessLevel)
    }

    func updateChosenGoals(_ goals: [String]) {
        chosenGoals = goals
        write(goals, key: "wellphone.chosenGoals")
    }

    func smallSteps(for goal: String) -> [String] {
        switch goal.lowercased() {
        case "write a book":
            return ["Write one paragraph of a story", "Write one page of a story", "Write one sentence of a story"]
        case "do better academically", "do better in school", "read more":
            return ["Work on one assignment step", "Read one page for class"]
        case "get a job", "find a job":
            return ["Take one step on a job application"]
        case "increase fitness", "get stronger":
            return fitnessExercises().map(\.title)
        case "better sleep", "sleep more consistently":
            return ["Set a steady bedtime", "Put my phone away before bed"]
        case "improve my home", "make my space feel better":
            return ["Reset one small area", "Put away five things"]
        case "learn a creative skill":
            return ["Practice for five minutes", "Try one new idea"]
        default:
            return ["Take one small step toward this goal"]
        }
    }

    func isSmallStepComplete(goal: String, step: String) -> Bool {
        completedSmallSteps.contains(Self.smallStepKey(goal: goal, step: step))
    }

    func toggleSmallStep(goal: String, step: String) {
        let key = Self.smallStepKey(goal: goal, step: step)
        if completedSmallSteps.contains(key) { completedSmallSteps.remove(key) }
        else { completedSmallSteps.insert(key) }
        write(Array(completedSmallSteps), key: "wellphone.completedSmallSteps")
    }

    func fitnessProgressValue(goal: String, exercise: FitnessExercise) -> Int {
        fitnessProgress[Self.smallStepKey(goal: goal, step: exercise.title)] ?? 0
    }

    func recordFitnessProgress(goal: String?, exercise: FitnessExercise, value: Int) {
        guard let goal else { return }
        let key = Self.smallStepKey(goal: goal, step: exercise.title)
        let progress = min(max(value, 0), exercise.target)
        fitnessProgress[key] = progress
        if progress >= exercise.target { completedSmallSteps.insert(key) }
        write(fitnessProgress, key: "wellphone.fitnessProgress")
        write(Array(completedSmallSteps), key: "wellphone.completedSmallSteps")
    }

    func goals(for date: Date = .now) -> [String] {
        Array((dailyGoals[Self.dayKey(date)] ?? []) + Array(repeating: "", count: 3)).prefix(3).map { $0 }
    }

    func saveGoals(_ goals: [String], for date: Date = .now) {
        let cleaned = Array(goals.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.prefix(3))
        dailyGoals[Self.dayKey(date)] = cleaned
        write(dailyGoals, key: "wellphone.dailyGoals")
    }

    func saveReflection(goals: [String], statuses: [String], date: Date = .now) {
        let key = Self.dayKey(date)
        reflections[key] = GoalReflection(date: key, goals: goals, statuses: statuses)
        write(reflections, key: "wellphone.reflections")
    }

    func routine(_ id: RoutineKind, date: Date) -> RoutineRecord {
        routineRecords[Self.routineKey(id, date)] ?? RoutineRecord()
    }

    func completeStep(_ id: RoutineKind, date: Date, total: Int, skipped: Bool = false) {
        let key = Self.routineKey(id, date)
        var record = routineRecords[key] ?? RoutineRecord()
        if record.index < total {
            if skipped { record.skipped.append(record.index) }
            else { record.completed.append(record.index) }
            record.index += 1
        }
        routineRecords[key] = record
        write(routineRecords, key: "wellphone.routineRecords")
    }

    func resetRoutine(_ id: RoutineKind, date: Date) {
        routineRecords.removeValue(forKey: Self.routineKey(id, date))
        write(routineRecords, key: "wellphone.routineRecords")
    }

    func logChoice(kind: String, title: String, detail: String) {
        activityChoices.insert(ActivityChoice(kind: kind, title: title, detail: detail), at: 0)
        activityChoices = Array(activityChoices.prefix(100))
        write(activityChoices, key: "wellphone.activityChoices")
    }

    func clearRecentChoices() {
        activityChoices = []
        write(activityChoices, key: "wellphone.activityChoices")
    }

    func clearAllLocalActivity() {
        activityChoices = []
        reflections = [:]
        routineRecords = [:]
        completedSmallSteps = []
        dailyGoals = [:]
        fitnessProgress = [:]
        write(activityChoices, key: "wellphone.activityChoices")
        write(reflections, key: "wellphone.reflections")
        write(routineRecords, key: "wellphone.routineRecords")
        write(Array(completedSmallSteps), key: "wellphone.completedSmallSteps")
        write(dailyGoals, key: "wellphone.dailyGoals")
        write(fitnessProgress, key: "wellphone.fitnessProgress")
    }

    static func dayKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func routineKey(_ kind: RoutineKind, _ date: Date) -> String {
        "\(kind.rawValue)-\(dayKey(date))"
    }

    private static func smallStepKey(goal: String, step: String) -> String {
        "\(goal)|\(step)"
    }
}

enum WellPhoneStyle {
    static let green = Color(red: 49/255, green: 90/255, blue: 70/255)
    static let canvas = Color(red: 245/255, green: 247/255, blue: 243/255)
    static let ink = Color(red: 23/255, green: 35/255, blue: 29/255)
    static let muted = Color(red: 120/255, green: 134/255, blue: 125/255)
    static let lime = Color(red: 225/255, green: 239/255, blue: 204/255)
    static let border = Color(red: 232/255, green: 236/255, blue: 230/255)
}

enum RoutineKind: String, CaseIterable, Identifiable {
    case morning, windDown
    var id: String { rawValue }
    var title: String { self == .morning ? "Morning Start" : "Wind Down" }
    var symbol: String { self == .morning ? "sun.max.fill" : "moon.stars.fill" }
    var window: String { self == .morning ? "4:00 AM – 11:59 AM" : "5:00 PM – 3:59 AM" }
    var steps: [String] {
        if self == .morning {
            return ["Get up and open the curtains", "Set 3 goals for today", "Use the bathroom, brush your teeth, and wash your face", "Do your morning skincare and hair routine", "Get dressed", "Eat breakfast or prepare something for later", "Collect your bag and put anything else you need by the door", "Check your calendar and choose your first priority"]
        }
        return ["Reflect on the goals you set this morning", "Pack your bag for tomorrow and put it by the door", "Clean one area", "Set out your clothes for tomorrow", "Set any alarms you need for tomorrow", "Brush your teeth", "Do your skincare routine", "Do your nighttime hair maintenance", "Close the curtains", "Plug your phone in where you want it for the night", "Choose a quiet last activity"]
    }
}
