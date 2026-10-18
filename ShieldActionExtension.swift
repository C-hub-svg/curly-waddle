import ManagedSettings
import Foundation

final class ShieldActionExtension: ShieldActionDelegate {
    private let defaults = UserDefaults(suiteName: "group.com.wellphone.app")

    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        respond(to: action, completionHandler: completionHandler)
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        respond(to: action, completionHandler: completionHandler)
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        respond(to: action, completionHandler: completionHandler)
    }

    private func respond(
        to action: ShieldAction,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        guard action == .primaryButtonPressed else {
            completionHandler(.close)
            return
        }

        defaults?.set(true, forKey: "wellphone.redirectAfterShield")
        if #available(iOS 26.5, *) {
            completionHandler(.openParentalControlsApp)
        } else {
            completionHandler(.close)
        }
    }
}
