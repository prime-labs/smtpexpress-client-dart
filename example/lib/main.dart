import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smtpexpress/smtpexpress.dart';

void main() {
  runApp(const MyApp());
}

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
        projectSecret: '28627898db4affbb5e882aaee3617cbd293fddc15a9059a51e',
        projectId: 'sm0pid-s9RFHSey4FMnk5OjCUeuSBjq2')
  );

  startSmtpExpress() async {
    try {
      // Prepare SendMailOptions
      final options = SendMailOptions(
        subject: 'Test Email',
        sender: MailSender(name: 'Ibukun', email: 'sm0pid-s9RFHSey4FMnk5OjCUeuSBjq2@projects.smtpexpress.com'),
        recipients: ['ibkokunoye@gmail.com', ],
        // Optionally include attachments, template, or calendar event
        message: 'This is a test email sent using SMTP Express',
        //responseAddress: 'hibetech01@gmail.com',
        /*template: MailTemplate(
          id: '1vueg6ucRcxRVMxPeuvUn',
          variables: {
            'firstName': 'Emmanuel',
          },
        ),*/
        attachments: filePaths,
        calendarEvent: CalendarEventOptions(
          title: 'Meeting with Ibk',
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


