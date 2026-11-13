# Night City — Windows build route

This project is SwiftUI. Windows cannot compile a native iOS app with Xcode locally, so this repository includes a GitHub Actions workflow that uses a hosted macOS runner to build an **unsigned** IPA.

## Build the IPA from a Windows PC

1. Create/sign in to a GitHub account and create a **private** repository.
2. Upload the contents of this project ZIP to the repository (keep the `.github/workflows/build-ipa.yml` file and folders).
3. Open the repository's **Actions** tab and run **Build Night City IPA** (or push to `main`).
4. When the workflow completes, open its run and download the `NightCityEdgerunners-unsigned-IPA` artifact. Extract the downloaded artifact ZIP to get `NightCityEdgerunners-unsigned.ipa`.
5. Install Sideloadly on Windows from https://sideloadly.io/ and connect the iPhone by USB.
6. Drag the unsigned IPA into Sideloadly, enter your Apple ID in Sideloadly itself, and start sideloading. Never send your Apple ID password to anyone in chat.
7. On iPhone, if prompted, enable Developer Mode under Settings > Privacy & Security > Developer Mode, then trust the developer profile under Settings > General > VPN & Device Management.

## Important

- This workflow builds an unsigned package; Sideloadly performs the signing and installation using your Apple ID.
- A free Apple ID provisioning profile normally expires after 7 days. Sideloadly documents automatic refresh when the PC and phone are available over USB or configured Wi-Fi.
- This is an app/dashboard, not a replacement for iOS SpringBoard, the lock screen, or system-wide icons.
- The app uses original interface styling and text, not official Cyberpunk/Edgerunners artwork or logos.
