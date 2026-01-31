# iOS Publishing Checklist

## Critical for iOS App Store Submission

### 1. Info.plist Permissions ⚠️ MOST IMPORTANT
Location: `ios/Runner/Info.plist`

Add these keys if not present:
```xml
<key>NSCameraUsageDescription</key>
<string>Atlas needs camera access to take photos and videos for your posts</string>

<key>NSMicrophoneUsageDescription</key>
<string>Atlas needs microphone access to record videos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Atlas needs access to your photo library to select images for posts</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Atlas needs permission to save photos to your library</string>
```

### 2. Before TestFlight Upload
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `cd ios && pod repo update && pod install && cd ..`
- [ ] Test on real iOS device: `flutter run -d <device-id> --release`
- [ ] Verify camera works on device
- [ ] Verify logout works
- [ ] Verify usernames display from Firebase

### 3. Build for App Store
```bash
# In Xcode:
# 1. Product → Archive
# 2. Distribute App → App Store Connect
# 3. Include Info.plist in build

# OR via CLI:
flutter build ipa --release
```

### 4. App Store Connect Setup
- [ ] Create App Store listing
- [ ] Add privacy policy URL (mention camera/photo access)
- [ ] Set age rating (if camera, likely 12+)
- [ ] Upload build from Xcode
- [ ] Add screenshot showing camera feature
- [ ] Add description mentioning camera/photo features

### 5. Privacy Policy Requirements
Include statement like:
> "Atlas uses your device's camera and microphone to capture photos and videos for posts. These files are uploaded to our servers. We do not store video outside of your posts."

### 6. Common iOS Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Camera appears unavailable | Info.plist missing keys | Add all 4 keys listed above |
| Permission denied at runtime | Simulator or no permissions | Test on real device, grant permissions |
| Build fails | CocoaPods issue | Run `cd ios && pod install` |
| Camera works in dev, not in TestFlight | Archive missing Info.plist | Verify all plist keys are in archive |
| Firebase upload fails on iOS | Network/storage rules | Check Firebase Security Rules |

### 7. Quick Test Commands
```bash
# Test on device
flutter run -d <device-id>

# Test release build
flutter run -d <device-id> --release

# Build for App Store
flutter build ios --release

# Check for warnings
flutter build ios --verbose 2>&1 | grep -i warning
```

### 8. After Publishing
- [ ] Monitor crash reports in App Store Connect
- [ ] Check user reviews for camera issues
- [ ] If users report camera not working, check:
  - Do they have permissions granted?
  - Are they on iOS 14+ (requires explicit permission)?
  - Is their device compatible with camera_picker plugin?

---

## Quick Reference: What Code Was Fixed

✅ **Camera Code**: No changes needed - code is correct
✅ **Logout Code**: No changes needed - working correctly  
✅ **Username Source**: FIXED - now uses only Firebase 'username' field

Files modified for username fix:
1. `lib/Pages/camera_page.dart` - Line 82
2. `lib/Tabs/home_tab.dart` - Line 89
3. `lib/Tabs/groups_tab.dart` - Line 86
4. `lib/PopUps/map_menu_popup.dart` - Line 46

---

## If Camera Doesn't Work After Publishing

**90% Chance**: Info.plist missing permissions  
**Check**:
1. ✅ All 4 permission strings added to Info.plist
2. ✅ Archive includes updated Info.plist
3. ✅ User grants permission in Settings
4. ✅ Device supports ImagePicker plugin

**Still broken?**
- Test directly on iOS device
- Run with `flutter logs` to see errors
- Check: `flutter doctor -v` for iOS setup issues
- Verify Xcode build settings have camera capability enabled

---

See [VERIFICATION_REPORT.md](VERIFICATION_REPORT.md) for complete technical details.
