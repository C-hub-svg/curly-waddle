# WellPhone

WellPhone helps people pause before opening selected distracting apps and choose a small next step that supports their goals. The repository contains a native iOS app and a lightweight browser prototype. ChatGPT was used in making this app.

## Native iOS app

The SwiftUI app is in [`WellPhone/WellPhone.xcodeproj`](WellPhone/WellPhone.xcodeproj). It targets iOS 17 and includes Screen Time shield extensions.

### Open and run

1. Open `WellPhone/WellPhone.xcodeproj` in Xcode.
2. Select the `WellPhone` scheme and an iPhone simulator or connected iPhone.
3. Build and run.

To use Screen Time app shields on a device, configure signing for the app and its extensions. The project uses the Family Controls entitlement and the `group.com.wellphone.app` app group. Apple may require approval for Family Controls distribution entitlements. In the app, open **Your plan → Choose apps to shield** and approve Screen Time access.

### App features

- Choose long-term goals during onboarding and edit them later in **Your plan**.
- For fitness goals, select Beginner, Intermediate, Advanced, or Elite. Each level has 15 guided options across mobility, strength, and cardio, with time estimates from 1 to 15 minutes.
- Use the **Today**, **Routine**, **Redirect**, and **Insights** tabs to manage goals, routines, check-ins, and recent choices. Safari appears as the blocked-app demo on Today; select Safari in Your plan to apply its native Screen Time shield.
- Redirect includes unfinished saved steps as well as quick activities. Fitness guides support partial progress, an optional countdown timer, and optional spoken cues.
- Select apps, categories, and websites for Screen Time shields. A temporary window exempts one explicitly chosen app while keeping the other selections shielded, and can be ended early from Today.
- Data such as goals, routines, and activity history is stored locally with UserDefaults and the app group. Some redirections open external websites and require an internet connection.

Screen Time behavior is controlled by iOS. On iOS 26.5 and later, the shield action can open WellPhone and route to Redirect. On earlier versions, iOS does not provide that host-app launch response: the shield action closes the blocked app, and the user can then open WellPhone manually. The app cannot send a notification every time another app is opened.

## Browser prototype

The root `index.html`, `app.css`, `app.js`, `manifest.webmanifest`, and `service-worker.js` make up a separate browser prototype. Serve the repository root locally:

```sh
python3 -m http.server 8000
```

Then open <http://localhost:8000>. The browser prototype does not have access to iOS Screen Time shields or native app blocking.

## Main files

- `WellPhone/WellPhone/ContentView.swift` — SwiftUI screens and interaction flows.
- `WellPhone/WellPhone/WellPhoneStore.swift` — local goals, routines, fitness catalog, and activity storage.
- `WellPhone/WellPhone/AppBlockingStore.swift` — Screen Time authorization, selections, and shield state.
- `WellPhone/ShieldConfiguration/` — appearance of the iOS shield.
- `WellPhone/ShieldAction/` — shield button handling.
- `WellPhone/DeviceActivityMonitor/` — timed app availability window.
