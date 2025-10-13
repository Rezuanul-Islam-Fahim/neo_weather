# GitHub Actions Workflow Architecture

## 🔄 Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     TRIGGER EVENT                                │
│  (Pull Request to master branch or Manual workflow dispatch)    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SETUP ENVIRONMENT                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Checkout     │  │ Setup Java   │  │ Setup Flutter │         │
│  │ Repository   │→ │ JDK 17       │→ │ 3.35.6 Stable│         │
│  │ (Full Git)   │  │ (Temurin)    │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RESTORE CACHES                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Flutter SDK  │  │ Pub Cache    │  │ Gradle Cache │         │
│  │ Cache        │  │              │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│  Cache Hit?  YES → Fast Build (3-5 min)                        │
│              NO  → Full Build (8-10 min)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BUILD PROCESS                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ flutter      │→ │ flutter pub  │→ │ Create .env  │         │
│  │ doctor -v    │  │ get          │  │ with API key │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                              │                   │
│                                              ▼                   │
│                    ┌──────────────┐  ┌──────────────┐          │
│                    │ flutter      │→ │ flutter build│          │
│                    │ analyze      │  │ apk --release│          │
│                    └──────────────┘  └──────────────┘          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    POST-BUILD ACTIONS                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Rename APK   │→ │ Generate     │→ │ Upload as    │         │
│  │ with Version │  │ SHA256       │  │ Artifact     │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                              │                   │
│                                              ▼                   │
│                    ┌──────────────┐  ┌──────────────┐          │
│                    │ Get Artifact │→ │ Store        │          │
│                    │ ID via API   │  │ Artifact ID  │          │
│                    └──────────────┘  └──────────────┘          │
│                                                                  │
│  APK Name: neo_weather-{VERSION}.apk (e.g., 1.1.1+7)           │
│  Includes: APK + SHA256 checksum                                │
│  Retention: 30 days                                             │
│  Artifact ID: Used for direct download links                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                APPETIZE DEPLOYMENT LOGIC                         │
│                                                                  │
│  Check: Does APPETIZE_PUBLIC_KEY exist?                         │
│                                                                  │
│  ┌───────────────────────┐    ┌──────────────────────┐         │
│  │ NO (First Time)       │    │ YES (Update)         │         │
│  │                       │    │                      │         │
│  │ ┌─────────────────┐   │    │ ┌────────────────┐  │         │
│  │ │ curl POST       │   │    │ │ curl POST      │  │         │
│  │ │ /v1/apps        │   │    │ │ /v1/apps/{key} │  │         │
│  │ │ (New Upload)    │   │    │ │ (Update)       │  │         │
│  │ └────────┬────────┘   │    │ └────────┬───────┘  │         │
│  │          │            │    │          │          │         │
│  │          ▼            │    │          ▼          │         │
│  │ ┌─────────────────┐   │    │ ┌────────────────┐  │         │
│  │ │ Parse Response  │   │    │ │ Parse Response │  │         │
│  │ │ Extract:        │   │    │ │ Extract:       │  │         │
│  │ │ - publicKey     │   │    │ │ - publicKey    │  │         │
│  │ │ - publicURL     │   │    │ │ - publicURL    │  │         │
│  │ └────────┬────────┘   │    │ └────────┬───────┘  │         │
│  │          │            │    │          │          │         │
│  │          ▼            │    │          ▼          │         │
│  │ ┌─────────────────┐   │    │ ┌────────────────┐  │         │
│  │ │ Display in      │   │    │ │ Use existing   │  │         │
│  │ │ Summary with    │   │    │ │ key for future │  │         │
│  │ │ instructions to │   │    │ │ updates        │  │         │
│  │ │ save Public Key │   │    │ │                │  │         │
│  │ └─────────────────┘   │    │ └────────────────┘  │         │
│  └───────────────────────┘    └──────────────────────┘         │
│                                                                  │
│  Implementation: Direct curl API calls with jq for parsing      │
│  Benefits: Better control, reliable URL extraction              │
│  Note: continue-on-error: true (Build succeeds even if fails)  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GENERATE OUTPUTS                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Workflow     │  │ PR Comment   │  │ Build        │         │
│  │ Summary      │  │ (if PR)      │  │ Artifacts    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│  Contains:                                                       │
│  • Build information (version, build number, date)              │
│  • Build status (analysis, APK, Appetize upload)                │
│  • Direct download links (GitHub artifacts with artifact ID)    │
│  • Live preview link (Appetize.io, if successful)               │
│  • SHA256 checksum for security                                 │
│                                                                  │
│  Download Link Format:                                          │
│  {server_url}/{repo}/actions/runs/{run_id}/artifacts/{id}      │
│                                                                  │
│  Appetize Link: Direct URL from upload response                 │
│  (e.g., https://appetize.io/app/{publicKey})                   │
└─────────────────────────────────────────────────────────────────┘
```

## 📦 Caching Strategy

```
┌──────────────────────────────────────────────────────────────┐
│                      CACHE LAYERS                             │
└──────────────────────────────────────────────────────────────┘

Layer 1: Flutter SDK Cache
├── Location: ${{ runner.tool_cache }}/flutter
├── Key: flutter-:os:-:channel:-:version:-:arch:-:hash:
├── Size: ~800 MB
├── Invalidates: When Flutter version changes
└── Saves: 2-3 minutes per build

Layer 2: Pub Dependencies Cache  
├── Location: ~/.pub-cache, .dart_tool
├── Key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
├── Size: ~100-300 MB
├── Invalidates: When pubspec.lock changes
└── Saves: 1-2 minutes per build

Layer 3: Gradle Dependencies Cache
├── Location: ~/.gradle/caches, ~/.gradle/wrapper, android/.gradle
├── Key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', 'gradle-wrapper.properties') }}
├── Size: ~500 MB - 1 GB
├── Invalidates: When Gradle config changes
└── Saves: 2-4 minutes per build

Layer 4: Java Distribution Cache
├── Location: Managed by setup-java action
├── Cache: 'gradle' (automatic)
├── Size: ~200 MB
├── Invalidates: When Java version changes
└── Saves: 30-60 seconds per build

Total Time Saved: 6-10 minutes on subsequent builds!
```

## 🔐 Secret Management

```
┌──────────────────────────────────────────────────────────────┐
│                    GITHUB SECRETS                             │
└──────────────────────────────────────────────────────────────┘

Required Secrets:
┌─────────────────────────┐
│ OPENWEATHER_API_KEY     │  ← Required for app functionality
│                         │    (Get from OpenWeather API)
└─────────────────────────┘
┌─────────────────────────┐
│ APPETIZE_API_TOKEN      │  ← Required for Appetize deployment
│                         │    (Get from Appetize.io)
└─────────────────────────┘

Optional (After First Deployment):
┌─────────────────────────┐
│ APPETIZE_PUBLIC_KEY     │  ← Add after first successful run
│                         │    (Provided in workflow output)
│                         │    Enables app updates instead of
│                         │    creating new apps each time
└─────────────────────────┘

Secret Usage Flow:
1. OPENWEATHER_API_KEY → Injected into .env file during build
2. APPETIZE_API_TOKEN → Used for Appetize.io API authentication
3. APPETIZE_PUBLIC_KEY → Determines new upload vs. update
   ├── Not set → curl POST creates new app, returns publicKey + publicURL
   └── Set → curl POST updates existing app with same publicKey
   
API Response Example:
{
  "publicKey": "abc123xyz",
  "publicURL": "https://appetize.io/app/abc123xyz"
}
```

## 🎯 Decision Tree

```
                    Start Workflow
                         │
                         ▼
         ┌───────────────────────────┐
         │ Trigger: PR to master     │
         │ or Manual dispatch?       │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Setup Environment         │
         │ • Java 17                 │
         │ • Flutter 3.35.6          │
         │ • Restore Caches          │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Extract Version from      │
         │ pubspec.yaml              │
         │ (e.g., 1.1.1+7)           │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Create .env file with     │
         │ OPENWEATHER_API_KEY       │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ flutter analyze           │
         │ (Code quality check)      │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ flutter build apk         │
         │ --release                 │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Rename APK with version   │
         │ Generate SHA256 checksum  │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Upload to GitHub          │
         │ Artifacts (30 days)       │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Get Artifact ID via       │
         │ GitHub API                │
         │ (For direct download)     │
         └──────────┬────────────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Is APPETIZE_PUBLIC_KEY    │
         │ defined in secrets?       │
         └──────────┬────────────────┘
                    │
          ┌─────────┴─────────┐
          │                   │
         NO                  YES
          │                   │
          ▼                   ▼
   ┌────────────┐      ┌────────────┐
   │ NEW UPLOAD │      │   UPDATE   │
   │            │      │  EXISTING  │
   │ POST       │      │    APP     │
   │ /v1/apps   │      │            │
   │            │      │ POST       │
   │            │      │ /v1/apps/  │
   │            │      │ {key}      │
   └──────┬─────┘      └─────┬──────┘
          │                   │
          ▼                   ▼
   ┌────────────┐      ┌────────────┐
   │ Receive    │      │ Keep same  │
   │ new public │      │ public key │
   │ key        │      │            │
   │            │      │ Update     │
   │ Display in │      │ confirmed  │
   │ summary    │      │            │
   └──────┬─────┘      └─────┬──────┘
          │                   │
          └─────────┬─────────┘
                    │
                    ▼
         ┌───────────────────────────┐
         │ Generate Deployment       │
         │ Summary & PR Comment      │
         │                           │
         │ • Build info              │
         │ • Direct download link    │
         │   (with artifact ID)      │
         │ • Appetize URL (if set)   │
         │ • SHA256 checksum         │
         └───────────────────────────┘
```

## 📊 Build Timeline Comparison

```
First Build (No Cache):
┌────────────────────────────────────────────────────────────┐
│ Checkout           ████ 30s                                │
│ Setup Java         ██████████ 60s                          │
│ Setup Flutter      ████████████████████ 120s               │
│ Flutter Doctor     ████ 20s                                │
│ Pub Get            ████████████ 80s                        │
│ Analyze            ████ 30s                                │
│ Gradle Setup       ████████████████ 100s                   │
│ Flutter Build APK  ████████████████████████████████ 200s   │
│ Rename & Checksum  ██ 10s                                  │
│ Appetize Upload    ████████ 45s                            │
└────────────────────────────────────────────────────────────┘
Total: ~11 minutes

Subsequent Build (With Cache):
┌────────────────────────────────────────────────────────────┐
│ Checkout           ████ 30s                                │
│ Setup Java         ██ 15s (cached)                         │
│ Setup Flutter      ████ 25s (cached)                       │
│ Flutter Doctor     ██ 10s                                  │
│ Pub Get            ██ 15s (cached)                         │
│ Analyze            ██ 10s                                  │
│ Gradle Setup       ████ 30s (cached)                       │
│ Flutter Build APK  ████████████████ 90s                    │
│ Rename & Checksum  ██ 10s                                  │
│ Appetize Upload    ████████ 45s                            │
└────────────────────────────────────────────────────────────┘
Total: ~4.5 minutes

⚡ Speed Improvement: ~2.5x faster with caching!
```

## 🔄 Continuous Deployment Flow

```
Developer                GitHub Actions              Appetize.io
    │                          │                         │
    │  Create PR or           │                         │
    │  Trigger Workflow       │                         │
    ├────────────────────────►│                         │
    │                          │                         │
    │                          │  Setup Environment     │
    │                          ├──────────┐             │
    │                          │          │             │
    │                          │◄─────────┘             │
    │                          │                         │
    │                          │  Build APK             │
    │                          ├──────────┐             │
    │                          │          │             │
    │                          │◄─────────┘             │
    │                          │                         │
    │                          │  Upload APK            │
    │                          ├────────────────────────►│
    │                          │                         │
    │                          │  Return Public Key +   │
    │                          │  App URL               │
    │                          │◄────────────────────────┤
    │                          │                         │
    │  Workflow Complete      │                         │
    │  • PR Comment           │                         │
    │  • Summary              │                         │
    │  • Artifacts            │                         │
    │◄────────────────────────┤                         │
    │                          │                         │
    │  Download APK from      │                         │
    │  GitHub Artifacts       │                         │
    │◄────────────────────────┤                         │
    │                          │                         │
    │  OR Test in Browser                               │
    │  (Appetize.io)                                    │
    ├───────────────────────────────────────────────────►│
    │                                                    │
    │  App runs in emulator                             │
    │◄───────────────────────────────────────────────────┤
    │                                                    │
```

## 📝 Version Extraction Process

```
┌─────────────────────────────────────────────────────────────┐
│                  pubspec.yaml                                │
│                                                              │
│  version: 1.1.1+7                                           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │ grep '^version:'      │
         │ awk '{print $2}'      │
         └──────────┬────────────┘
                    │
                    ▼ "1.1.1+7"
         ┌───────────────────────┐
         │ Parse Version String  │
         ├───────────────────────┤
         │ VERSION="1.1.1+7"     │
         │ APP_VERSION="1.1.1"   │ ← cut -d'+' -f1
         │ BUILD_NUMBER="4"      │ ← cut -d'+' -f2
         └──────────┬────────────┘
                    │
                    ▼
         ┌───────────────────────┐
         │ Generate APK Name     │
         ├───────────────────────┤
         │ neo_weather-1.1.1+7   │
         │ .apk                  │
         └──────────┬────────────┘
                    │
                    ▼
         ┌───────────────────────┐
         │ Export as Outputs     │
         ├───────────────────────┤
         │ version=1.1.1+7       │
         │ app_version=1.1.1     │
         │ build_number=4        │
         │ apk_name=neo_weather- │
         │          1.1.1+7.apk  │
         └───────────────────────┘
```

## 🔒 Security Features

```
┌──────────────────────────────────────────────────────────────┐
│                      SECURITY MEASURES                        │
└──────────────────────────────────────────────────────────────┘

1. API Key Protection
   ├── Stored in GitHub Secrets (encrypted at rest)
   ├── Injected only during build process
   ├── Never logged or exposed in output
   └── .env file not committed to repository

2. Build Integrity
   ├── SHA256 checksum generated for APK
   ├── Checksum included in artifact download
   ├── Users can verify APK hasn't been tampered with
   └── Verification command provided in documentation

3. Minimal Permissions
   ├── contents: read (no write access to repo)
   ├── pull-requests: write (only for comments)
   └── issues: write (for issue comments if needed)

4. Dependency Security
   ├── Actions pinned to major versions (@v4, @v2)
   ├── Official GitHub actions used
   ├── Gradle checksum verification enabled
   └── Regular dependency updates via Dependabot

5. Artifact Management
   ├── 30-day retention (automatic cleanup)
   ├── Compressed ZIP format
   ├── Includes both APK and checksum
   └── Access controlled by GitHub permissions

Verification Example:
# Verify downloaded APK
sha256sum -c neo_weather-1.1.1+7.apk.sha256

Expected output:
neo_weather-1.1.1+7.apk: OK
```

## 🎨 Workflow Outputs

```
┌──────────────────────────────────────────────────────────────┐
│                   GITHUB STEP SUMMARY                         │
└──────────────────────────────────────────────────────────────┘

# 🚀 Deployment Summary

## 📱 Application Information
- App Name: Neo Weather
- Version: 1.1.1
- Build Number: 4
- APK Name: neo_weather-1.1.1+7.apk
- Build Date: 2025-10-14 12:34:56 UTC
- Commit SHA: abc1234567

## 📊 Build Status
- Code Analysis: ✅ Passed
- APK Build: ✅ Success
- Appetize Upload: ✅ Success (or ⚠️ Failed or Skipped)

## 📥 Download & Test
- **GitHub Artifact:** [neo_weather-1.1.1+7.apk](Direct Download Link)
  > 💡 **Tip:** Click the link above to download the APK directly.
- **Appetize.io:** [Test App Online](https://appetize.io/app/...) (if successful)
  > Click the link above to test your app in the browser!

## 🔐 Security
- SHA256 checksum included in artifact

---

┌──────────────────────────────────────────────────────────────┐
│                    PR COMMENT (if applicable)                 │
└──────────────────────────────────────────────────────────────┘

# 🚀 Build & Deployment Report

## 📱 Application Details
| Property | Value |
|----------|-------|
| App Name | Neo Weather |
| Version | 1.1.1 |
| Build Number | 4 |
| APK Name | neo_weather-1.1.1+7.apk |
| Build Date | Mon, 14 Oct 2025 12:34:56 GMT |
| Commit | abc1234567 |

## 📊 Build Status
- Code Analysis: ✅ Passed
- APK Build: ✅ Success
- Appetize Upload: ✅ Success
- Artifact Upload: ✅ Success

## 📥 Download & Test
- **📦 Download APK:** [neo_weather-1.1.1+7](Direct link to artifact)
  
  > 💡 **Tip:** Click the link above to download the APK directly.

- **🎮 Test on Appetize.io:** [Launch App](https://appetize.io/app/...)
  
  Click the link above to test your app in the browser!

## 🔐 Security
- SHA256 checksum is included in the artifact for integrity verification

---
*This build was automatically generated by GitHub Actions*
*Workflow: [12345678]*
```

## 🛠️ Troubleshooting Guide

```
┌──────────────────────────────────────────────────────────────┐
│                   COMMON ISSUES & SOLUTIONS                   │
└──────────────────────────────────────────────────────────────┘

Issue 1: Build Timeout (30 minutes exceeded)
├── Symptom: Workflow cancelled automatically
├── Cause: Slow network or first-time build without cache
└── Solution: Re-run workflow (cache will be available)

Issue 2: Flutter Analyze Fails
├── Symptom: Build fails at analyze step
├── Cause: Code quality issues or linting errors
└── Solution: Run `flutter analyze` locally and fix issues

Issue 3: Appetize Upload Fails
├── Symptom: Appetize step fails but workflow continues
├── Cause: Invalid API token or service unavailable
├── Solution: 
│   ├── Verify APPETIZE_API_TOKEN secret exists
│   ├── Check token hasn't expired
│   └── Check Appetize.io service status

Issue 4: Missing .env File Error
├── Symptom: Build fails with "API key not found"
├── Cause: OPENWEATHER_API_KEY secret not configured
└── Solution: Add secret in repository settings

Issue 5: APK Not Found
├── Symptom: Artifact upload fails
├── Cause: Build didn't complete successfully
└── Solution: Check Flutter build logs for errors

Issue 6: Cache Not Working
├── Symptom: Build takes full time every run
├── Cause: Cache keys changing or cache evicted
└── Solution: 
│   ├── Check if pubspec.lock or gradle files changed
│   ├── Verify cache restore logs
│   └── May be normal after dependency updates

Issue 7: Version Extraction Fails
├── Symptom: Invalid version number or APK name
├── Cause: pubspec.yaml version format incorrect
└── Solution: Ensure version follows format: X.Y.Z+B
    Example: 1.1.1+7
```

## 📈 Performance Metrics

```
Target Metrics:
├── Build Time (Cached): < 5 minutes
├── Build Time (Uncached): < 12 minutes
├── Cache Hit Rate: > 80%
├── Success Rate: > 95%
├── APK Size: 25-40 MB
└── Artifact Upload Time: < 1 minute

Current App Metrics (v1.1.1+7):
├── Dependencies: 7 packages
├── Min SDK: Android SDK set by Flutter
├── Target SDK: 35
└── Supported Platforms: Android, iOS
```

## 🔄 Workflow Job Outputs

```yaml
Available Outputs (for downstream jobs):

outputs:
  app_version: ${{ steps.get_version.outputs.version }}
    # Example: "1.1.1+7"
  
  build_number: ${{ steps.get_version.outputs.build_number }}
    # Example: "5"
  
  apk_name: ${{ steps.get_version.outputs.apk_name }}
    # Example: "neo_weather-1.1.1+7.apk"
  
  appetize_url: ${{ steps.upload_appetize.outputs.publicURL }}
    # Example: "https://appetize.io/app/xyz123..."
  
  artifact_id: ${{ steps.get_artifact.outputs.artifact_id }}
    # Example: "123456789"
    # Used for direct download links

Usage in downstream jobs:
  needs: build-and-upload
  steps:
    - run: echo "Version ${{ needs.build-and-upload.outputs.app_version }}"
```

## 📚 Related Documentation

- **Main README:** `README.md` - Project overview and setup
- **Workflow File:** `.github/workflows/build_and_deploy.yml` - Actual workflow
- **Copilot Instructions:** `.github/copilot-instructions.md` - AI coding guidelines
- **Environment Template:** `.env.example` - Environment variable template

---

**Architecture Version:** 1.0  
**Last Updated:** October 14, 2025  
**Current App Version:** 1.1.1+7  
**Flutter Version:** 3.35.6  
**Dart Version:** 3.5.0+  
**Java Version:** 17 (Temurin Distribution)  
**Target Android SDK:** 35
