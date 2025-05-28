#!/bin/bash

echo "🌊 FloodScope AI - Mobile APK Builder"
echo "===================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found"

# Navigate to project directory
cd "$(dirname "$0")"

echo "📦 Getting Flutter dependencies..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "🔧 Building APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS! FloodScope AI APK built successfully!"
    echo ""
    echo "📱 APK Location:"
    echo "   build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📊 APK Features:"
    echo "   ✅ Real-time flood monitoring"
    echo "   ✅ Interactive flood risk maps"
    echo "   ✅ Weather-based flood analysis"
    echo "   ✅ AI-powered flood predictions"
    echo "   ✅ Location-based alerts"
    echo "   ✅ Historical flood data"
    echo ""
    echo "🚀 Installation Instructions:"
    echo "   1. Copy APK to your Android device"
    echo "   2. Enable 'Install from Unknown Sources' in Settings"
    echo "   3. Install the APK file"
    echo "   4. Grant location permissions for real-time monitoring"
    echo ""
    
    # Check APK size
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        apk_size=$(du -h "build/app/outputs/flutter-apk/app-release.apk" | cut -f1)
        echo "📁 APK Size: $apk_size"
    fi
    
else
    echo "❌ Failed to build APK"
    echo "💡 Try running: flutter doctor"
    exit 1
fi