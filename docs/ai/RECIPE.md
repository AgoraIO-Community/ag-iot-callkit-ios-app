# iOS IoT CallKit App

## Overview

Use the Agora Link CallKit library and its iOS demo to handle account/device calls, notifications and live device media.

Repository: [AgoraIO-Community/ag-iot-callkit-ios-app](https://github.com/AgoraIO-Community/ag-iot-callkit-ios-app)

## Prerequisites and Setup

1. Use Xcode, CocoaPods and a physical device running iOS 13 or later.
2. Provision an Agora Link project and compatible device. Replace the masked values in `CallkitDemo/CallkitDemo/Model/Config.swift` with your app, product, project and service endpoint settings; configure notification/APNs values when testing push.
3. From `CallkitDemo/`, run `pod install` and open `CallkitDemo.xcworkspace`. The checked-in Podfile uses the local AgoraIotCallkit library.
4. Set your signing team and capabilities, build the demo and use its account/device calling flow with the provisioned peer.

## What To Check

- Log in and confirm that the correct device/account can be called.
- Test incoming, answered and ended calls with device video/audio.
- Verify notification behavior separately with your own push configuration.

## Integration Notes

The README's generic Example directory instruction does not match the checked-in `CallkitDemo/` layout. The project contains legacy toolchain settings and masked service configuration; resolve those with the compatible IoT SDK before a device run.

Keep App Certificates, customer secrets and privileged token generation on a trusted backend for production. Use only your own test credentials while configuring historical demos; do not commit them. Preserve the sample's existing dependency versions and lifecycle until a separate migration is tested.

## Source References

- [README.md](../../README.md)
- [CallkitDemo/Podfile](../../CallkitDemo/Podfile)
- [CallkitDemo/CallkitDemo/Model/Config.swift](../../CallkitDemo/CallkitDemo/Model/Config.swift)

## Validation Status

This recipe was checked against the repository's source and setup documents. The platform build and live service/device flow have not been run as part of this documentation change. Complete the checks above in an environment with the required SDKs, hardware and service access before treating it as a validated deployment.

## Implementation Prompt

```text
You are working in AgoraIO-Community/ag-iot-callkit-ios-app. Use docs/ai/RECIPE.md and its linked source files to adapt the iOS IoT CallKit App reference to this project.

Start by inspecting the actual sample directory and configuration described above. Resolve its listed missing prerequisites before claiming it is runnable. Preserve the existing architecture and compatible dependency versions. Implement the recipe's feature-specific flow, permissions and resource cleanup. Use a trusted backend for privileged credentials and tokens in production.

Run the repository-specific build or launch flow, then perform each What To Check item. Report the commands run, the observed results and anything blocked by service access, hardware or incomplete sample code. Do not claim live validation from a documentation or catalog build alone.
```
