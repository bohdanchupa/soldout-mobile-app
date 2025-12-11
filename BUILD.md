# Soldout App - Build Guide

## 📋 Зміст
1. [Вимоги](#вимоги)
2. [Локальна розробка](#локальна-розробка)
3. [iOS білд](#ios-білд)
4. [Android білд](#android-білд)
5. [GitHub Actions](#github-actions)
6. [Troubleshooting](#troubleshooting)

---

## Вимоги

### Системні вимоги
- **Node.js**: 14 (для сумісності з node-sass)
- **Docker**: Рекомендується для ізольованого білду
- **macOS**: Для iOS білдів

### Залежності
```bash
# Встановіть залежності
npm install

# Cordova залежності
cd src-cordova
npm install
cd ..
```

---

## Локальна розробка

### Використання Docker (Рекомендовано)

Docker забезпечує консистентне середовище Node 14 + sass@1.23.0:

```bash
# Створіть Docker контейнер
docker build -t soldout-app .

# Запустіть контейнер
docker run -d --name soldout-app-container \
  --platform linux/amd64 \
  -v "$(pwd):/app" \
  -w /app \
  -p 4200:4200 \
  soldout-app \
  tail -f /dev/null

# Запустіть dev сервер
docker exec -it soldout-app-container npx quasar dev --hostname 0.0.0.0

# Відкрийте: http://localhost:4200
```

### Використання NVM (Альтернатива)

```bash
# Встановіть NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Встановіть Node 14
nvm install 14
nvm use 14

# Запустіть dev сервер
npx quasar dev
```

---

## iOS білд

### Вимоги для iOS
- macOS
- Xcode (остання версія)
- Apple Developer Account (або безкоштовний Personal Team)
- Фізичний iPhone для тестування

### Крок 1: Білд Web Assets

```bash
./rebuild-ios.sh
```

Цей скрипт:
- Збирає web assets в Docker (Node 14 + sass@1.23.0)
- Копіює в `src-cordova/www/`
- Запускає `cordova prepare ios`
- Інжектує `cordova.js` в index.html

### Крок 2: Відкриття в Xcode

```bash
open src-cordova/platforms/ios/Soldout\ Event.xcworkspace
```

⚠️ **Важливо**: Завжди відкривайте `.xcworkspace`, НЕ `.xcodeproj`!

### Крок 3: Налаштування Signing

1. Під'єднайте iPhone до Mac через USB
2. Розблокуйте iPhone і натисніть "Trust This Computer"
3. У Xcode виберіть пристрій (меню вгорі)
4. Signing & Capabilities → Team: [Ваш Apple ID]

### Крок 4: Збірка і Запуск

```bash
# У Xcode:
Product → Clean Build Folder (⌘⇧K)
Product → Run (⌘R)
```

### Крок 5: Налагодження

```bash
# Safari Web Inspector для живих логів
Safari → Develop → [Ваш iPhone] → Soldout Event
```

### Перший запуск на новому пристрої

Якщо iPhone показує "Untrusted Developer":
1. iPhone → Settings → General → VPN & Device Management
2. Натисніть на ваш Apple ID → Trust

---

## Android білд

### Вимоги для Android
- Android Studio
- Android SDK (API 28+)
- Java JDK 8
- Gradle

### Налаштування середовища

Додайте до `~/.zshrc` або `~/.bash_profile`:

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/$(ls $ANDROID_HOME/build-tools | tail -1)
```

### Білд APK

```bash
# Використовуйте готовий скрипт
./build-apk.sh

# Або вручну:
npx quasar build -m cordova -T android --debug

# APK буде в:
# src-cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### Підписання APK для Play Store

```bash
# Генерація keystore (один раз)
keytool -genkey -v -keystore soldout-release-key.keystore \
  -alias soldout -keyalg RSA -keysize 2048 -validity 10000

# Білд release APK
npx quasar build -m cordova -T android --release

# Підписання APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore soldout-release-key.keystore \
  src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  soldout

# Вирівнювання APK
zipalign -v 4 \
  src-cordova/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  soldout-signed.apk
```

---

## GitHub Actions

### Автоматичні білди

GitHub Actions налаштовано для автоматичної збірки APK:

1. **Push до GitHub**:
   ```bash
   git add .
   git commit -m "Update"
   git push
   ```

2. **Вручну запустити**:
   - Actions tab → "Build Android APKs"
   - Run workflow → Select "both"

3. **Завантажити APK**:
   - Actions → Latest run → Artifacts
   - `soldout-test-apk.zip`
   - `soldout-prod-apk.zip`

### Конфігурація

Файли:
- `.github/workflows/build-apk.yml` - основний workflow
- `setup-github.sh` - скрипт налаштування

---

## Troubleshooting

### Node.js/Sass Compatibility

**Проблема**: Modern Node.js + old Quasar v1 + node-sass incompatibility

**Рішення**: Використовуйте Docker з Node 14 + sass@1.23.0

### CORS 403 на Mobile

**Проблема**: iOS WKWebView sends OPTIONS preflight, ZUUL returns 403

**Рішення**:
1. Configure CORS in ZUUL with `allow-credentials: true`
2. Use `cordova-plugin-http` for native HTTP
3. Avoid custom headers when possible

### Cordova deviceready Not Firing

**Проблема**: Plugins not available

**Рішення**:
1. Ensure `cordova.js` is loaded BEFORE app.js
2. Check `src/index.template.html` has `<script src="cordova.js">`
3. Run `cordova prepare ios`

### iOS Signing Errors

**Проблема**: "Signing requires a development team"

**Рішення**: Open Xcode → Signing & Capabilities → Select Team

### Xcode не бачить iPhone

**Рішення**:
1. Перевірте USB кабель
2. Розблокуйте iPhone і натисніть "Trust This Computer"
3. Перезапустіть Xcode
4. Window → Devices and Simulators

### ANDROID_HOME not set

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
```

### Gradle build failed

```bash
# Clean and rebuild
rm -rf src-cordova/platforms src-cordova/plugins src-cordova/www
npx quasar build -m cordova -T android
```

---

## API Configuration

### Переключення середовищ

Файл: `src/api/endpoints.js`

```javascript
// TEST
const serviceUrl = 'https://z.test.soldout.com.ua'

// PROD
// const serviceUrl = 'https://z.soldout.com.ua'
```

### Готові endpoints файли

- `src/api/endpoints.js` - TEST (за замовчуванням)
- `src/api/endpoints-prod.js` - PROD

---

## Швидкі команди

```bash
# Локальна розробка
npm run dev

# Web білд
npx quasar build

# iOS rebuild
./rebuild-ios.sh

# Android APK
./build-apk.sh

# Test CORS
./test-cors.sh

# Cordova commands
cd src-cordova
cordova platform add ios
cordova prepare ios
cordova plugin list
```

---

## Чек-лист перед релізом

### iOS
- [ ] Clean Build Folder (⌘⇧K)
- [ ] Тест на фізичному iPhone
- [ ] Safari Web Inspector - перевірка помилок
- [ ] Login/Logout flow працює
- [ ] API requests працюють

### Android
- [ ] APK встановлюється
- [ ] Тест на реальному пристрої
- [ ] Login/Logout flow працює
- [ ] API requests працюють

---

## Корисні ресурси

- **Quasar Framework**: https://quasar.dev
- **Cordova**: https://cordova.apache.org/docs/en/latest/
- **Vue.js 2**: https://v2.vuejs.org
- **Vuex**: https://v3.vuex.vuejs.org

---

*Останнє оновлення: Грудень 2025*

