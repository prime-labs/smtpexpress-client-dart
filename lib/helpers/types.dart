

// SendMailOptions class, ensuring at least one of message or template is present
class SendMailOptions {
  final String subject;
  final MailSender sender;
  final dynamic recipients; // String, List<String>, MailRecipient, or List<MailRecipient>
  final String? message;
  final MailTemplate? template;
  final List<MailAttachment>? attachments;
  final CalendarEventOptions? calendarEvent;
  final ResponseAddress? responseAddress;

  SendMailOptions({
    required this.subject,
    required this.sender,
    required this.recipients,
    this.message,
    this.template,
    this.attachments,
    this.calendarEvent,
    this.responseAddress,
  }) : assert((message != null || template != null), 'Either message or template must be provided');
}

class CredentialOptions {
  final String projectSecret;
  final String projectId;

  CredentialOptions({
    required this.projectSecret,
    required this.projectId,
  });
}




class MailTemplate {
  final String id;
  final Map<String, String> variables;

  MailTemplate({
    required this.id,
    required this.variables,
  });
}

/*
class MailAttachment {
  final dynamic data; // String, File, or MailTemplate

  MailAttachment(this.data);
}
*/

typedef MailAttachment = String?;

typedef ResponseAddress = String?;

class MailRecipient {
  final String? name;
  final String email;

  MailRecipient({
    this.name,
    required this.email,
  });
}

class MailSender extends MailRecipient {
  MailSender({
    required String name,
    required String email,
  }) : super(name: name, email: email);
}

class CalendarEventOptions {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? location;
  final String? url;
  final String? organizer;

  CalendarEventOptions({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description,
    this.location,
    this.url,
    this.organizer,
  });
}

