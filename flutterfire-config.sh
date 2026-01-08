#!/bin/bash
# Script to generate Firebase configuration files (no flavors)

flutterfire config \
  --project=rapidd-technologies-task \
  --out=lib/firebase_options/firebase_options.dart \
  --ios-bundle-id=com.example.rapiddTechnologiesTask \
  --ios-out=ios/GoogleService-Info.plist \
  --android-package-name=com.example.rapidd_technologies_task \
  --android-out=android/app/google-services.json

# USAGE:
# chmod +x flutterfire-config.sh
# ./flutterfire-config.sh
