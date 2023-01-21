## firebase setup
1. create project in firebase

### firebase auth
1. __for android auth setup__
    - change `package name and add multiDexEnabled true` in android/app/build.gradle
    - get sha1 key from your machine `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android ` and key is `23:6F:6F:D5:72:F2:D9:C7:30:7A:D9:8F:F9:07:3D:97:36:60:70:63`
    - create a new android app in firebase and follow the steps
        - download google-services.json and paste it in android/app folder
        - add sdks in gradle files
    - add dependencies
        ```yaml
            firebase_core: 1.19.1
            firebase_core_web: 1.6.6
            firebase_auth: 3.4.1
            google_sign_in: ^5.3.3
            firebase_core_platform_interface: 4.5.1
            # cloud_firestore:
        ```
    - `WidgetsFlutterBinding.ensureInitialized(); && await Firebase.initializeApp();` in main.dart
    - write sign in and sign out methods in [auth.repo.dart](lib/utils/auth.repo.dart)
        ```dart
        static Future<gsignin.GoogleSignInAccount?> signIn() async {
            try {
            final googleSignIn = gsignin.GoogleSignIn( scopes: <String>['email'] );
            final gsignin.GoogleSignInAccount? gsiAccountUser = await googleSignIn.signIn();
            if (gsiAccountUser == null) return null;
                return gsiAccountUser;
            } catch (e) {
                throw ("error static Future<gsignin.GoogleSignInAccount?> signIn() : $e");
            }
        }

        static Future<void> signOut() async {
            try {
            final googleSignIn = gsignin.GoogleSignIn();
            await googleSignIn.signOut();
            } catch (e) {
                throw ("error static Future<void> signOut() : $e");
            }
        }
        ```
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
            // to avoid duplicate app name exists error
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