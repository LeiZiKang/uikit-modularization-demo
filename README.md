# UIKit modularization demo

A small iOS 17+ project that backs the article
[Splitting an old UIKit project into modules](https://levi-blog.pages.dev/blog/uikit-modularization-en/).
It shows three dependency lines and checks one page in five states.

- **Components**: `BadgeLabel` takes only a `Configuration` (text and color). It knows nothing about the API.
- **DataModel**: `ItemDTO` keeps the API meaning; `ItemViewModel` turns it into display text.
- **DevTools**: a small facade that registers mocks (DEBUG only) and shows alerts through one entry. The mock and alert here are in-memory stand-ins, not real tool packages.
- **App**: `ItemViewController` takes an `ItemAPI`. `FixtureItemAPI` returns one of five scenes: success, empty, loading, 401, 500.

```text
App -> Components
App -> DataModel
App -> DevTools
(Components, DataModel and DevTools do not depend on each other)
```

All three packages are local Swift Packages, so nothing is downloaded. The point is the dependency direction, not the package manager.

## Run

Open `ModularDemo.xcodeproj`, pick the `ModularDemo` scheme and an iOS 17+ simulator. Launch argument `-scene empty|loading|401|500` selects another fixture (default is success).
The five `#Preview`s are at the bottom of `App/ItemViewController.swift`.

```sh
xcodebuild test -project ModularDemo.xcodeproj -scheme ModularDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## What was checked

- Build and 5 XCTest cases (one per state) pass on an iOS Simulator.
- The five `#Preview`s render in Xcode's canvas through Xcode's RenderPreview.

| State | App in Simulator | Xcode canvas |
| --- | --- | --- |
| Success | `docs/screenshots/01-success.png` | `docs/screenshots/canvas-01-success.png` |
| Empty | `docs/screenshots/02-empty.png` | `docs/screenshots/canvas-02-empty.png` |
| Loading | `docs/screenshots/03-loading.png` | `docs/screenshots/canvas-03-loading.png` |
| 401 | `docs/screenshots/04-unauthorized.png` | `docs/screenshots/canvas-04-401.png` |
| 500 | `docs/screenshots/05-serverError.png` | `docs/screenshots/canvas-05-500.png` |

## What this does not check

It does not exercise URLProtocol interception or a real network path. The fixtures are in memory, so they test copy, layout and state branches only.

One gotcha found while rendering previews: `while true { ... }` in the Loading fixture breaks Xcode Preview, because Preview rewrites `true` and the compiler can no longer see the loop never exits (`missing return`). The fixture loops on `!Task.isCancelled` and throws `CancellationError()` afterwards.

MIT licensed.
