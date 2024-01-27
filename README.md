# SMTP Express Package
A package to send emails using SMTP Express

# 💻  Getting started

Add the SmtpExpress package dependency to your pubspec.yaml file like this:
```yaml
dependencies:
  smtpexpress: 0.1.4
```

# Import
Import the flutter load_kit package like so:
```dart
import 'package:smtpexpress/smtpexpress.dart';
```

## Usage
```dart
import 'package:flutter/material.dart';
import 'package:smtpexpress/smtpexpress.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmtpExpress Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String?> filePaths = [];

  var smtpExpressClient = createClient(
      CredentialOptions(
      projectSecret: 'PROJECT_SECRET',
      projectId: 'PROJECT_ID'
  )
  );

  startSmtpExpress() async {
    try {
      // Prepare SendMailOptions
      final options = SendMailOptions(
        subject: 'Test Email',
        sender: MailSender(name: 'James', email: 'SENDER-ADDRESS'),
        recipients: ['example@mail.com'],
        // Optionally include attachments, template, or calendar event
        message: 'This is a test email sent using SMTP Express',
        responseAddress: 'RESPONSE_ADDRESS',
        template: MailTemplate(
          id: 'PLACEHOLDER_TEMPLATE_ID',
          variables: {
            'firstName': 'Samuel',
          },
        ),
        attachments: filePaths,
        calendarEvent: CalendarEventOptions(
          title: 'Meeting with Sarah',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(minutes: 5)),
        ),

      );

      // Send the email
      final response = await smtpExpressClient.sendApi.sendMail(options);

      // Handle successful response
      if (kDebugMode) {
        print('Response: $response');
      }
    } catch (error) {
      // Handle errors
      if (kDebugMode) {
        print('Error sending email: $error');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Start SMTP Express
                  startSmtpExpress();
                },
                child: const Text('Send Mail'),
              ),

              const SizedBox(height: 8),

              // Select files
              ElevatedButton(
                onPressed: () async {
                  // Trigger file selection
                  final result = await FilePicker.platform.pickFiles(allowMultiple: true);

                  if (result != null) {
                    // Do something with the file path, e.g., display it or open the file
                    filePaths = result.paths;

                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text('Select Files'),
              ),
            ],
          ),
        )
    );
  }
}

```


## BUGS/CONTRIBUTIONS/REQUESTS
If you encounter any problems using this package, please feel free to open an [issue](https://github.com/mayowa-ola/zeeh-plugin/issues).

If you'd like to contribute to this package, kindly open a pull request [here](https://github.com/mayowa-ola/zeeh-plugin)
