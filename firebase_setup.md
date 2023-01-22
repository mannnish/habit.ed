## firebase setup
1. create project in firebase

### firebase auth
1. __for android auth setup__
    - change `package name and add multiDexEnabled true` in android/app/build.gradle
    - get sha1 key from your machine `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android ` and key is `23:6F:6F:D5:72:F2:D9:C7:30:7A:D9:8F:F9:07:3D:97:36:60:70:63`
    - create a new android app in firebase and follow the steps
        - download google-services.json and paste it in android/app folder
        - add sdks in gradle files
    - change gradle file dedfault config to `minSdkVersion 29 & targetSdkVersion 31`
    - add dependencies
        ```yaml
        # dart -> 2.16.1
        # flutter -> 2.10.2 
        cloud_firestore: 3.5.1
        cloud_firestore_web: 2.8.10
        cloud_firestore_platform_interface: 5.7.7
        firebase_auth: 3.4.2
        firebase_core: 1.24.0
        firebase_core_web: 1.7.3
        firebase_core_platform_interface: 4.5.1
        google_sign_in: 5.4.3
        shared_preferences: 2.0.17
        ```
    - `WidgetsFlutterBinding.ensureInitialized(); && await Firebase.initializeApp();` in main.dart
    - write sign in and sign out methods in [auth.repo.dart](lib/utils/auth.repo.dart)
2. __for web auth setup__
    - add web app in firebase and name it "<project> web app"
    - copy the cdn code and paste it in web/index.html
    - for sign in code, you will just need web client id from __firebase Authentication > Sign in method > Google Web SDK Configuration__ tab and add it in GoogleSignIn() object
        ```dart
        final googleSignIn = gsignin.GoogleSignIn(
            clientId: 'xxx.apps.googleusercontent.com',
            scopes: <String>['email'],
        );
        ```
    - __error 1 : "FirebaseOptions cannot be null when creating the default app."__
        - to solve this, go to firebase console and add web app and copy the config code and pass it as FirebaseOptions in main.dart
        ```dart
        void main() async {
            WidgetsFlutterBinding.ensureInitialized();
            // to avoid duplicate app name exists error - 
            // in earlier versions we used to initiliaze firebase in web.html
            if (kIsWeb) {
                await Firebase.initializeApp(options: const FirebaseOptions(...));
            } else {
                await Firebase.initializeApp();
            }
            runApp(const MyApp());
        }
        ```
    - __error static Future<gsignin.GoogleSignInAccount?> signIn() : PlatformException(idpiframe_initialization_failed, Not a valid origin for the client: http://localhost:34661 has not been registered for client ID 691675216102-rn949cv6802m64ok80jtc1cl13mtohf7.apps.googleusercontent.com. Please go to https://console.developers.google.com/ and register this origin for your project's client ID., https://developers.google.com/identity/sign-in/web/reference#error_codes, null)__
        - you can either use port 5000 (using below step) or use custom port or link your firebase project with your google cloud project
        - to solve it create a launch.json with a fixed port for localhost 
            ```json
            {
                "version": "0.2.0",
                "configurations": [
                    {
                        "name": "Fl-Default",
                        "request": "launch",
                        "type": "dart",
                    },
                    {
                        "name": "Fl-Chrome",
                        "request": "launch",
                        "type": "dart",
                        "args": ["-d", "chrome", "--web-port","59688"]
                    }
                ]
            }
            ```
        - Now to add that host `59688` to the gcp project console
        - go to [console.developers.google.com](https://console.developers.google.com/) and Select your project (if you cant see your firebase project, search it in the search bar. __DONT CREATE A NEW PROJECT__).
        - go to __APIs & Services > Credentials > OAuth 2.0 Client IDs > Web client (auto created by firebase) > Authorized JavaScript origins__ and add `http://localhost:59688`
        - if there are multiple entries, then open them all and match the web client id and token with firebase Authentication Google web client id and token


### firebase web
1. `firebase init` and select hosting
1. What do you want to use as your public directory? build/web
1. Configure as a single-page app (rewrite all urls to /index.html)? No
1. Set up automatic builds and deploys with GitHub? No
1. change title in html file and yaml file
1. change favicon in web folder, and replace icons files in web/icons folder

---
1. change version before deploying `flutter_service_worker.js?v=` in index.html
1. `flutter build web` to build the app
1. `firebase deploy` to deploy the app


### app changing title and icons
1. Steps to change app name in Android:
    - Navigate to the android>app> src>main and open the AndroidManifest.xml file. 
    - Under the application tag, Find the android:label and replace its value with the new app name.
1. Steps to change app icons in Android:
    - use this website to generate icons [icon kitchen](https://icon.kitchen/)
    - hit download after generating icons
    - create a folder named assets/icons and put your main icon.png in it and other icons in respective folders
    - in yaml, install `flutter_launcher_icons: ^0.9.2` and add this in yaml
        ```yaml
        flutter_icons:
            android: true
            ios: true
            image_path: "assets/icons/icon.png"
        ```
    - now run `flutter pub get && flutter pub run flutter_launcher_icons:main` and it will generate icons for you
    - do `flutter build apk` and verify


### Version Control
 - Change the version in yaml file and in app/build.gradle file
 - # if mandatory update, then only change in version.code and firebase
 - Change Version.code class variable (create a class and put the same version code for easy access)
 - For web, Change the version code in web/index.html file 
<img src="https://i.stack.imgur.com/5FUZJ.jpg">


### SIGNING APP
 - __GENERATING KEYSTORE__  : copy keystore command to generate keyfile.jks from [here](https://flutter.dev/docs/deployment/android) or use this command `keytool -genkey -v -keystore ~/<appname>-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
 - store the passwords you enter, you will need it later.
 - <b>KEYSTORE SHAs</b> : now get the keystore SHA keys from Machine, ```keytool -list -v -keystore ~/<appname>-key.jks -alias {alias_name i.e. upload}``` and for password enter keyPassword.
 - <b>PLAY CONSOLE SHAs </b> : After releasing your app on to the play store, copy the SHA keys from App integrity section
 - Add these SHA keys in your firebase
 - --
 - create a file, android/key.properties and these lines
 ```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload // notice from step 3 keyalias is "upload"
storeFile=<location of the key store file, such as /Users/<user name>/upload-keystore.jks>
```
 - In android/app/build.gradle, change your applicationId if you havent already, and for version number change it from .yaml
 - Add the keystore information from your properties file before the android {} block:
 ```
 def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
        ...
}
```
 - Replace buildTypes block with 
 ```
    signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }
```
 - --
 - run ```flutter build appbundle```
