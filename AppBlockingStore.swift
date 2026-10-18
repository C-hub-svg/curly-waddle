import FamilyControls
import DeviceActivity
import ManagedSettings
import SwiftUI

@MainActor
final class AppBlockingStore: ObservableObject {
    @Published var selection: FamilyActivitySelection
    @Published private(set) var authorizationStatus: AuthorizationStatus
    @Published var errorMessage: String?
    @Published private(set) var availabilityEndDate: Date?

    private let settings = ManagedSettingsStore()
    private let defaults = UserDefaults(suiteName: "group.com.wellphone.app") ?? .standard
    private let selectionKey = "wellphone.blockedApps.selection"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let availabilityUntilKey = "wellphone.availability.until"
    private let availabilityAllowedAppKey = "wellphone.availability.allowedApplication"
    private let availabilityActivity = DeviceActivityName("com.wellphone.app.availability-window")

    init() {
        if let data = defaults.data(forKey: selectionKey),
           let saved = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            selection = saved
        } else {
            selection = FamilyActivitySelection()
        }
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        availabilityEndDate = defaults.object(forKey: availabilityUntilKey) as? Date
        applySelection()
    }

    func authorize() async throws -> Bool {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        refreshAuthorization()
        return authorizationStatus == .approved
    }

    func refreshAuthorization() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        applySelection()
    }

    func saveSelection() {
        if let data = try? JSONEncoder().encode(selection) {
            defaults.set(data, forKey: selectionKey)
        }
        applySelection()
    }

    func makeAppsAvailable(for minutes: Int, allowing application: ApplicationToken) throws {
        guard authorizationStatus == .approved else {
            throw AvailabilityError.notAuthorized
        }
        guard selection.applicationTokens.contains(application) else {
            throw AvailabilityError.applicationNotSelected
        }
        guard let tokenData = try? encoder.encode(application) else {
            throw AvailabilityError.couldNotSaveApplication
        }

        let until = Date.now.addingTimeInterval(TimeInterval(minutes * 60))
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let start = Calendar.current.dateComponents(components, from: .now)
        let end = Calendar.current.dateComponents(components, from: until)
        let schedule = DeviceActivitySchedule(intervalStart: start, intervalEnd: end, repeats: false)
        let center = DeviceActivityCenter()
        center.stopMonitoring([availabilityActivity])
        defaults.set(tokenData, forKey: availabilityAllowedAppKey)
        defaults.set(until, forKey: availabilityUntilKey)
        do {
            try center.startMonitoring(availabilityActivity, during: schedule)
        } catch {
            defaults.removeObject(forKey: availabilityAllowedAppKey)
            defaults.removeObject(forKey: availabilityUntilKey)
            applySelection(allowing: nil)
            throw error
        }
        availabilityEndDate = until
        applySelection(allowing: application)
    }

    func endAvailabilityWindow() {
        DeviceActivityCenter().stopMonitoring([availabilityActivity])
        defaults.removeObject(forKey: availabilityUntilKey)
        defaults.removeObject(forKey: availabilityAllowedAppKey)
        availabilityEndDate = nil
        applySelection()
    }

    enum AvailabilityError: LocalizedError {
        case notAuthorized
        case applicationNotSelected
        case couldNotSaveApplication

        var errorDescription: String? {
            switch self {
            case .notAuthorized: "Allow Screen Time access in Your plan before creating an app access window."
            case .applicationNotSelected: "Choose one of the individually selected apps to allow during this window."
            case .couldNotSaveApplication: "WellPhone couldn’t save the selected app for this access window. Please try again."
            }
        }
    }

    private func applySelection() {
        guard authorizationStatus == .approved else { return }
        if let until = defaults.object(forKey: availabilityUntilKey) as? Date, until > .now {
            availabilityEndDate = until
            let allowed = defaults.data(forKey: availabilityAllowedAppKey).flatMap { try? decoder.decode(ApplicationToken.self, from: $0) }
            applySelection(allowing: allowed)
            return
        }
        defaults.removeObject(forKey: availabilityUntilKey)
        defaults.removeObject(forKey: availabilityAllowedAppKey)
        availabilityEndDate = nil
        applySelection(allowing: nil)
    }

    private func applySelection(allowing application: ApplicationToken?) {
        let exceptions = application.map { Set([$0]) } ?? []
        let blockedApplications = selection.applicationTokens.subtracting(exceptions)
        settings.shield.applications = blockedApplications.isEmpty ? nil : blockedApplications
        settings.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens
        settings.shield.applicationCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens, except: exceptions)
        settings.shield.webDomainCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens)
    }

}