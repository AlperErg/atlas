# Testing Guide - Verification Steps

## 🎥 Camera Testing

### Photo Capture
1. Open app → Camera tab
2. Click "Photo" button
3. Take a photo using device camera
4. Photo should appear in form
5. Add description and tags
6. Click "Upload" 
7. ✅ Post created with photo in Firebase Storage

### Video Recording
1. Open app → Camera tab
2. Click "Video" button
3. Record a short video (max 5 minutes)
4. Video should appear in form
5. Add description and tags
6. Click "Upload"
7. ✅ Post created with video in Firebase Storage

### Gallery Selection
1. Open app → Camera tab
2. Click "Gallery" button
3. Select multiple images from phone gallery
4. Images should populate in form
5. Upload post
6. ✅ All images uploaded and linked to post

## 🚪 Logout Testing

### Logout Flow
1. Go to Home tab
2. Tap profile name/header at top-left
3. Select "Logout" from dropdown menu
4. Confirmation dialog should appear
5. Click "OK" to confirm
6. App should show LoginScreen
7. ✅ User logged out, auth cleared

### Verification After Logout
1. Try navigating with back button - should stay on login
2. Clear app cache (Settings → Apps → Atlas → Clear Cache)
3. Reopen app - should show LoginScreen
4. ✅ No user data persisted

### Login After Logout
1. Login with Google again
2. Should show same registration/profile screen or main app if profile exists
3. All user data should be loaded correctly
4. ✅ Re-authentication works

## 👤 Username Verification

### Check Firestore is Used, Not Auth
1. Create a test user
2. Set Firestore `users/{uid}` document with `username: "TestUser123"`
3. In app, verify name shows "TestUser123" everywhere
4. Never shows the Google auth name or email
5. ✅ Verified in:
   - Camera page (when taking photo)
   - Home tab header
   - Posts in feed
   - User menu popup

### Test All Display Locations
1. Home tab - shows username at top-left ✅
2. Camera page - shows username when creating post ✅
3. Post feed - shows username on each post ✅
4. Profile menu - shows username ✅
5. Map pages - shows username ✅

## 📱 Platform-Specific Testing

### iOS Device
- [ ] Permissions dialog appears on first camera/gallery access
- [ ] Photo capture works
- [ ] Video recording works  
- [ ] Gallery picker works
- [ ] All uploads succeed to Firebase
- [ ] Logout works
- [ ] Usernames display correctly

### Android Device
- [ ] Camera works without issues
- [ ] Video recording works
- [ ] Gallery picker works
- [ ] All uploads succeed to Firebase
- [ ] Logout works
- [ ] Usernames display correctly

### Web Browser
- [ ] Camera page shows "Feature not available" message
- [ ] Cannot access camera/video features
- [ ] Logout works
- [ ] Other features work normally

## 🔍 Detailed Verification

### Firebase Firestore
Check `users/{currentUserId}` has:
```json
{
  "uid": "firebase-uid",
  "username": "YourUsername",
  "email": "your@email.com",
  "darkMode": false,
  "followers": [],
  "following": [],
  "groups": [],
  ...
}
```

Check `posts/{postId}` has:
```json
{
  "authorId": "firebase-uid",
  "username": "YourUsername",
  "userID": "some-id",
  "description": "Post description",
  "tags": ["tag1", "tag2"],
  "imageUrls": ["https://..."],
  "videoUrl": null,
  "likesCount": 0,
  "commentsCount": 0,
  "commentsEnabled": true,
  "donationsEnabled": true,
  "createdAt": "timestamp"
}
```

### Firebase Storage
After uploading:
- [ ] Photos: `posts/{postId}/image_0.png`, `image_1.png`, etc.
- [ ] Video: `posts/{postId}/video.mp4`
- [ ] All files have proper download URLs
- [ ] URLs are accessible from internet

## 📊 Test Results Checklist

### Must Pass
- [ ] Camera photo capture works on iOS
- [ ] Camera video capture works on iOS  
- [ ] Logout clears authentication
- [ ] All usernames from Firebase only
- [ ] Posts save to Firebase correctly
- [ ] Images/videos upload to Storage

### Nice to Have
- [ ] Proper error messages shown
- [ ] Loading indicators display
- [ ] Success notifications shown
- [ ] Graceful fallbacks for failures

## 🐛 Debug Commands

```bash
# See all logs
flutter logs

# Search for errors
flutter logs | grep -i error

# Test on specific device
flutter devices
flutter run -d <device-id>

# Release build test
flutter run -d <device-id> --release

# Check Firebase connectivity
flutter pub global run devtools
```

---

## Sign-Off Template

```
Platform: [iOS/Android/Web]
Date: ________
Tester: ________

Camera - Photo: ☐ Pass ☐ Fail
Camera - Video: ☐ Pass ☐ Fail  
Camera - Gallery: ☐ Pass ☐ Fail
Logout: ☐ Pass ☐ Fail
Usernames from Firebase: ☐ Pass ☐ Fail
Posts saved correctly: ☐ Pass ☐ Fail

Notes: _________________________________________________

Status: ☐ Ready for Publish ☐ Needs Fixes
```

---

See VERIFICATION_REPORT.md for technical details.
See IOS_PUBLISHING_CHECKLIST.md for App Store submission.
