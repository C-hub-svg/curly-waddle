import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings

final class AvailabilityMonitorExtension: DeviceActivityMonitor {
    private let settings = ManagedSettingsStore()
    private let defaults = UserDefaults(suiteName: "group.com.wellphone.app")
    private let selectionKey = "wellphone.blockedApps.selection"
    private let availabilityUntilKey = "wellphone.availability.until"
    private let availabilityAllowedAppKey = "wellphone.availability.allowedApplication"
    private let availabilityActivity = DeviceActivityName("com.wellphone.app.availability-window")

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        guard activity == availabilityActivity else { return }
        guard
            let data = defaults?.data(forKey: selectionKey),
            let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return }
        let allowed = defaults?.data(forKey: availabilityAllowedAppKey).flatMap { try? JSONDecoder().decode(ApplicationToken.self, from: $0) }
        apply(selection, allowing: allowed)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        guard activity == availabilityActivity else { return }
        defaults?.removeObject(forKey: availabilityUntilKey)
        defaults?.removeObject(forKey: availabilityAllowedAppKey)
        guard
            let data = defaults?.data(forKey: selectionKey),
            let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else { return }
        apply(selection, allowing: nil)
    }

    private func apply(_ selection: FamilyActivitySelection, allowing application: ApplicationToken?) {
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
