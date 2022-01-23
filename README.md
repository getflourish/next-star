# Next-star

This is a pet project to create an iOS OSS client for the [Nextcloud Bookmarks app](https://apps.nextcloud.com/apps/bookmarks).

As such, the quality of the Swift code in here is definitely not at the standard of a production-grade iOS app since I just started learning iOS development with Swift / SwiftUI with this project.

If you're looking for a more feature-complete and robust project, check the official Github repository of the Bookmarks app for the [recommended iOS clients](https://github.com/nextcloud/bookmarks#ios).

This is part of my efforts to maintain as many of the data points that I generate on my self-hosted services and generally be in control of my data. It's likely that a blogpost on [my blog](https://jay.cat) will follow explaining how to set up stuff in order to be able to host your own instance and run the app on your iOS device.

## Setup

### Shared UserDefaults and Keychain access

In order to make this repository work locally and deploying to a physical device, you'll have to replace all the `TEAM_ID` occurences in `next-star/next-star.entitlements`, `share-target/share-target.entitlements` and `next-star/Models/Constants.swift` files with your real `TEAM_ID`.

You can see the affected files here: https://github.com/JayKid/next-star/commit/987728700490000000df443c50cb84b7d07021c2
