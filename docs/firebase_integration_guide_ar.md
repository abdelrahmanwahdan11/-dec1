# دليل ربط Firebase الكامل مع تطبيق Plants Fresher

## مقدمة
Firebase منصة سحابية توفر خدمات جاهزة مثل المصادقة، قاعدة البيانات الفورية (Cloud Firestore)، التخزين (Cloud Storage)، الإشعارات (Cloud Messaging)، التحليلات (Analytics) والأعطال (Crashlytics). في هذا التطبيق سنستخدمها لتمكين تسجيل الدخول، مزامنة البيانات، رفع الملفات، استقبال الإشعارات، وتحليل استخدام التطبيق بدون الاعتماد على خادم خارجي.

## 1. إنشاء مشروع Firebase جديد
1. افتح [console.firebase.google.com](https://console.firebase.google.com) وسجّل الدخول.
2. اضغط "Add project" ثم أدخل اسم المشروع (مثال: plants-fresher).
3. يمكنك تفعيل Google Analytics إن أردت، واختر الحساب المرتبط.
4. أنشئ المشروع وانتظر حتى يكتمل الإعداد الأولي.

## 2. ربط تطبيقات Android / iOS / Web بالمشروع
1. من لوحة المشروع اضغط على أيقونة Android وأضف:
   - **Package name** يطابق التطبيق (مثال `com.example.plants_fresher`).
   - أضف **SHA-1/SH2** عبر Android Studio أو `./gradlew signingReport` لتحسين المصادقة.
   - حمّل ملف `google-services.json` وضعه في `android/app/`.
2. أضف تطبيق iOS:
   - أدخل **Bundle ID** المطابق لـ Runner.
   - حمّل ملف `GoogleService-Info.plist` وضعه في مجلد `ios/Runner/`.
   - فعّل Push Notifications و Background Modes من Xcode > Signing & Capabilities.
3. أضف تطبيق الويب:
   - سجّل عنوان الموقع إن وجد.
   - انسخ إعدادات الويب أو استخدم FlutterFire CLI لتوليد `firebase_options.dart`.
4. بدلاً من النسخ اليدوي، يمكنك تشغيل `flutterfire configure` لتوليد ملف `lib/firebase_options.dart` تلقائياً لكل منصة.

## 3. إضافة مكتبات Firebase إلى مشروع Flutter
1. افتح `pubspec.yaml` وتأكد من وجود الحزم التالية (مضافة بالفعل):
   - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`, `firebase_analytics`, `firebase_crashlytics`, `flutter_local_notifications`.
2. نفّذ:
   ```bash
   flutter pub get
   ```
3. إذا استخدمت FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   سيولّد الملف `lib/firebase_options.dart` بالقيم الصحيحة لكل منصة.

## 4. تهيئة Firebase داخل main.dart
1. داخل `lib/main.dart` تأكد من:
   - استدعاء `WidgetsFlutterBinding.ensureInitialized();` قبل أي شيء.
   - استدعاء `FirebaseInitializer.initializeFirebase();` قبل `runApp`.
2. الكود الحالي:
   ```dart
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await FirebaseInitializer.initializeFirebase();
     runApp(const PlantsFresherApp());
   }
   ```
3. ملف `lib/firebase_options.dart` يحتوي قيماً تجريبية؛ استبدلها بالقيم التي أنشأها FlutterFire CLI.

## 5. استخدام خدمة المصادقة (AuthService)
- الملف: `lib/core/firebase/auth_service.dart`.
- أمثلة سريعة:
  ```dart
  // تسجيل مستخدم جديد
  await AuthService.instance.signUpWithEmail(email, password);

  // تسجيل الدخول
  await AuthService.instance.signInWithEmail(email, password);

  // الخروج
  await AuthService.instance.signOut();

  // الاستماع لحالة التسجيل
  AuthService.instance.authStateChanges().listen((user) {
    // user == null يعني خروج
  });
  ```
- قبل الاستخدام، تأكد من تفعيل Email/Password من Firebase Console > Authentication > Sign-in method.

## 6. استخدام قاعدة البيانات (FirestoreService) لرفع وتعديل وحذف البيانات
- الملف: `lib/core/firebase/firestore_service.dart`.
- أمثلة عملية:
  ```dart
  // إضافة مستند جديد في مجموعة plants
  await FirestoreService.instance.addDocument('plants', {
    'name': 'Monstera',
    'price': 25,
    'createdAt': FieldValue.serverTimestamp(),
  });

  // تحديث مستند موجود
  await FirestoreService.instance.updateDocument('plants', 'docId', {'price': 30});

  // الاستماع إلى التغييرات في المجموعة
  final sub = FirestoreService.instance.streamCollection('plants').listen((snapshot) {
    final items = snapshot.docs.map((d) => d.data()).toList();
  });

  // حذف مستند
  await FirestoreService.instance.deleteDocument('plants', 'docId');
  ```
- استخدم `streamDocument` لتحديث شاشة تفاصيل عنصر فورياً.

## 7. استخدام التخزين (StorageService) لرفع الصور والفيديوهات
- الملف: `lib/core/firebase/storage_service.dart`.
- سيناريو شائع: رفع صورة ثم تخزين رابطها في Firestore.
  ```dart
  // بافتراض أنك حصلت على ملف من ImagePicker
  final downloadUrl = await StorageService.instance.uploadFile(myFile, 'uploads/user123/profile.jpg');
  await FirestoreService.instance.setDocument('users', 'user123', {'avatar': downloadUrl});
  ```
- للويب أو البيانات في الذاكرة، استخدم `uploadBytes` مع `Uint8List`.
- لحذف الملفات غير المستخدمة: `await StorageService.instance.deleteFile('uploads/user123/profile.jpg');`.

## 8. تفعيل الإشعارات (NotificationService و FCM)
- الملف: `lib/core/firebase/notification_service.dart`.
  - الخطوات:
  1. عند بدء التطبيق يتم استدعاء `initializeNotifications()` تلقائياً من `FirebaseInitializer` لطلب الصلاحيات وإعداد القنوات.
  2. احصل على رمز الجهاز واحفظه مع المستخدم:
     ```dart
     final token = await NotificationService.instance.getFcmToken();
     if (token != null && AuthService.instance.currentUser != null) {
       await FirestoreService.instance.setDocument('users', AuthService.instance.currentUser!.uid, {
         'fcmToken': token,
       });
     }
     ```
  3. الرسائل في وضع foreground تُعرَض كإشعار محلي عبر `listenToForegroundMessages()`.
  4. للويب، أضف `firebase-messaging-sw.js` في مجلد `web/` وأضف `messagingSenderId` الصحيح داخل service worker.
- فعّل Cloud Messaging من Firebase Console، وأضف مفاتيح APNs لتطبيق iOS إن لزم.

## 9. المزامنة والعمل في حالة عدم الاتصال
- Firestore يوفر كاش محلي تلقائي. يمكن للتطبيق القراءة من الكاش والعمل أوفلاين ثم المزامنة عند عودة الاتصال.
- تجنب اعتماد واجهات حيوية على استعلامات بلا مراقبة؛ استخدم Streams (`streamCollection`) لتحديث حي.

## 10. حل المشاكل الشائعة
- نسيان وضع `google-services.json` أو `GoogleService-Info.plist` يؤدي إلى فشل التهيئة.
- عدم تفعيل طريقة الدخول في Auth يسبب أخطاء `operation-not-allowed`.
- تأكد من ضبط `minSdkVersion` بما يتوافق مع Firebase (عادة 21+).
- للويب: تأكد من تضمين سكربتات Firebase في `index.html` إذا لم تستخدم FlutterFire options.
- أخطاء الإشعارات على iOS غالباً بسبب عدم تفعيل Push Notifications و Background Modes.

## 11. كيف تطوّر وتوسّع التكامل لاحقًا
- أضف طرق تسجيل جديدة (Google/Apple) عبر تمكينها في Auth واستخدام حزم `google_sign_in` أو `sign_in_with_apple` وربطها بـ Firebase Auth.
- أضف مجموعات جديدة في Firestore ببساطة عبر تغيير `collectionPath` في `FirestoreService` مع قواعد أمان مناسبة.
- وسّع التخزين لرفع أنواع ملفات إضافية أو إضافة مجلدات حسب كل مستخدم.
- أرسل أنواع مختلفة من الإشعارات (عروض، تذكير بالرعاية) بتخزين الـ token لكل مستخدم واستخدام Cloud Functions أو لوحة FCM لإرسال الرسائل.
