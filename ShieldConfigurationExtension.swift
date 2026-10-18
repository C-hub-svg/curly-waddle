import ManagedSettings
import ManagedSettingsUI
import UIKit

final class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        configuration()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        configuration()
    }

    private func configuration() -> ShieldConfiguration {
        let primaryButtonTitle: String
        let subtitle: String
        if #available(iOS 26.5, *) {
            primaryButtonTitle = "Open WellPhone"
            subtitle = "Take a moment to choose what you want to do next."
        } else {
            primaryButtonTitle = "Close blocked app"
            subtitle = "Then open WellPhone to continue to your redirect."
        }

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor(red: 245/255, green: 247/255, blue: 243/255, alpha: 1),
            icon: UIImage(systemName: "leaf.fill"),
            title: .init(text: "Make room for what matters.", color: UIColor(red: 23/255, green: 35/255, blue: 29/255, alpha: 1)),
            subtitle: .init(text: subtitle, color: UIColor(red: 75/255, green: 91/255, blue: 80/255, alpha: 1)),
            primaryButtonLabel: .init(text: primaryButtonTitle, color: .white),
            primaryButtonBackgroundColor: UIColor(red: 49/255, green: 90/255, blue: 70/255, alpha: 1),
            secondaryButtonLabel: .init(text: "Close", color: UIColor(red: 49/255, green: 90/255, blue: 70/255, alpha: 1))
        )
    }
}
