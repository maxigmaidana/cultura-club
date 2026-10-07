# Web Splash Screen Debugging Guide

## Problem Fixed
Flutter web app was stuck on HTML splash screen (red with logo) and never reached SplashScreen or Login.

## Root Causes Identified & Fixed

### 1. **SplashScreen Navigation Logic (CRITICAL)**
**Problem**: `ref.listen(userSessionProvider)` only fires on state CHANGES, not on initial resolved state.
- In web, when SplashScreen mounts, `userSessionProvider` is already resolved (not loading)
- No state change = no listener callback = **SplashScreen never navigates**

**Solution**: Replace `ref.listen()` with `ref.watch()` + `.when()` pattern
```dart
// BEFORE (broken):
ref.listen(userSessionProvider, (_, next) {
  if (!next.isLoading) { ... navigate ... }
});

// AFTER (works):
final userSessionAsync = ref.watch(userSessionProvider);
userSessionAsync.when(
  data: (user) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) GoRouter.of(context).go(HomeScreen.pathName);
      else GoRouter.of(context).go(LoginScreen.pathName);
    });
  },
  loading: () { /* show splash */ },
  error: (_, __) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).go(LoginScreen.pathName);
    });
  },
);
```

### 2. **Environment Variables Loading**
**Problem**: Unclear error messages if .env fails to load in web
**Solution**: 
- Better validation in main.dart
- Clear error messages indicating .env should be in `web/assets/`
- Non-fatal .env load failure (continue if file missing, fail if URL/key missing)

### 3. **HTML Splash Screen Not Removed**
**Problem**: Flutter bootstrap was not calling `removeSplashFromWeb()`
**Solution**: Created custom `web/flutter_bootstrap.js` that:
- Calls `removeSplash()` on Flutter's first frame
- Double-checks with setTimeout to ensure HTML splash is hidden

## Files Changed

### 1. `lib/features/auth/presentation/screens/splash_screen.dart`
- Changed navigation from `ref.listen()` to `ref.watch()` + `.when()`
- Added error handling branch
- Uses `addPostFrameCallback()` for safe navigation

### 2. `lib/main.dart`
- Enhanced .env loading with better error messages
- Validates SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY explicitly
- Added debug logging markers `[Web Init]`

### 3. `web/flutter_bootstrap.js` (NEW)
- Custom bootstrap that ensures HTML splash removal
- Removes splash on Flutter's first frame
- Fallback setTimeout for safety

## Expected Behavior After Fix

1. **HTML splash** appears (red with Cultura Club logo)
2. **Flutter initializes** (userSessionProvider.build() runs)
3. **HTML splash removed** by flutter_bootstrap.js
4. **Navigation occurs**:
   - If valid session → `/home` (HomeScreen)
   - If no session → `/login` (LoginScreen)
   - If session error → `/login` (fallback)
5. **Flutter app renders** (SplashScreen → target screen)

## Debugging Checklist

If app still doesn't work, check these in order:

### 1. **Web Console (DevTools F12)**
```
✓ No red JavaScript errors
✓ "✓ Loaded SUPABASE_URL from .env" message
✓ "✓ Loaded SUPABASE_PUBLISHABLE_KEY from .env" message
✓ "✓ Supabase initialized" message
✓ "✓ Flutter first frame rendered" message
✓ "✓ Hid HTML splash screen" message
```

If you DON'T see these messages, check:
- Is .env file present in `web/assets/.env`?
- Does .env contain SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY?
- Is web build including assets? Check `build/web/assets/.env` exists

### 2. **Check .env File**
```bash
cat web/assets/.env
# Should output:
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_PUBLISHABLE_KEY=eyJhbGc...
```

### 3. **Verify Build Output**
```bash
ls build/web/
# Should contain: index.html, manifest.json, flutter_bootstrap.js, main.dart.js, assets/

ls build/web/assets/
# Should contain: .env file
```

### 4. **Network Requests**
Check Network tab in DevTools:
- `flutter_bootstrap.js` - should load successfully
- `main.dart.js` - should load successfully
- No 404 errors for .env or bootstrap

### 5. **Session Restore Errors**
If you see `userSessionProvider` in error state:
- Check Supabase connection (URL and key are correct)
- Check Network tab for Supabase API errors
- If first time, no token exists = correct, should go to Login

## Testing Steps

1. **Clean build**:
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **Serve locally** (from build/web):
   ```bash
   cd build/web
   python -m http.server 8080
   ```

3. **Open in Chrome** and check:
   - Open http://localhost:8080
   - Open DevTools (F12)
   - Check Console for `[Web Init]` messages
   - Observe splash disappear
   - Verify navigation to /login or /home

4. **Test navigation**:
   - If sent to /login → good, no session
   - If sent to /home → good, valid session exists
   - If stays on / → problem, check console errors

## Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| White screen, no splash | Flutter not loading | Check Network tab for main.dart.js errors |
| Stuck on red splash | SplashScreen not navigating | Check [Web Init] messages in console |
| "SUPABASE_URL not found" | .env missing or not loaded | Verify web/assets/.env exists, check Network tab for .env load |
| Red splash disappears but then freezes | Navigation error in GoRouter | Check console for GoRouter errors |
| Splash disappears but no Flutter app | First frame callback timing issue | May need to adjust addPostFrameCallback timing |

## Vercel Deployment

After testing locally works:
1. Upload `build/web/` to Vercel
2. Ensure `.env` is included in deployment
3. Test in production browser DevTools same way

Note: PWA requires HTTPS to work properly
