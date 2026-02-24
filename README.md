# PDF to Image Premium (Flutter)

Production-grade Flutter app for converting real PDF pages to images with advanced settings and a premium UI.

## Features implemented

- PDF picker with strict validation (PDF-only, max 100 MB)
- Metadata display (name, size, page count)
- Conversion controls:
  - all pages or range parser (`1-5,8,10-15`)
  - PNG/JPG/WEBP
  - DPI presets + custom DPI
  - quality slider
  - grayscale toggle
  - compression optimization toggle
  - text watermark + opacity
- Live preview (first-page render)
- Batch conversion + ZIP export
- Smart auto naming
- Progress + real-time conversion logs
- Dark/light/system theme toggle
- Conversion history page
- Share images / ZIP via share sheet
- Isolate-based heavy image post-processing

## Clean architecture structure

```text
lib/
 ├── core/
 ├── data/
 ├── domain/
 ├── presentation/
 ├── services/
 └── utils/
```

## Setup

1. Ensure Flutter stable SDK (3.22+ recommended)
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run:
   ```bash
   flutter run
   ```

## Platform permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

Add (inside `<manifest>`):

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
```

### iOS (`ios/Runner/Info.plist`)

Add:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Allow saving converted images to your photo library.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow reading selected files and saving converted output.</string>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

## Example test case

Use any multi-page PDF (e.g., 10 pages) and set:
- Page range: `1-3,7`
- Format: `WEBP`
- DPI: `300`
- Grayscale: on
- Watermark: `CONFIDENTIAL`

Then convert and verify 4 images + ZIP are generated in app documents `/exports/<timestamp>/`.
