
import '../helpers/http_service.dart';
import '../helpers/types.dart';
import 'package:dio/dio.dart';

class SendApi {
  final HttpService httpService;

  SendApi(this.httpService);

  Future<Map<String, dynamic>> sendMail(SendMailOptions options) async {
    final formData = await getFormBody(options);
    final response = await httpService.sendRequest(
      HttpClientParams(
        method: 'post',
        path: '/send',
        body: formData, // Use formData directly for attachments
      ),
    );

  /*  if (response != null) {
      throw response; // Rethrow the error
    }*/

    return response;
  }


  Future<FormData> getFormBody(SendMailOptions options) async {

    final form = FormData.fromMap({
      'subject': options.subject,
      'sender': {
        'name': options.sender.name,
        'email': options.sender.email
      },
      'message': options.message,
    });

    form.fields.addAll(
      appendRecipients(options.recipients).entries.toList(),
    );
    form.fields.addAll(
        appendTemplate(options.template).entries.toList()
    );
    form.fields.addAll(
        appendCalendarEvent(options.calendarEvent).entries.toList()
    );
    form.fields.addAll(
        appendResponseAddress(options.responseAddress).entries.toList()
    );

    if (options.attachments != null) {
      for (var i = 0; i < options.attachments!.length; i++) {
        final file = await MultipartFile.fromFile(options.attachments![i]!);
        form.files.add(MapEntry('attachments', file)); // Use a unique key for each file
      }
    }

    return form;
  }

  Map<String, String> appendRecipients(dynamic recipients) {
    final recipientFields = <String, String>{};
    if (recipients is List) {
      for (var i = 0; i < recipients.length; i++) {
        final recipient = recipients[i];
        if (recipient is MailRecipient) {
          recipientFields.addAll({
            'recipients[$i][name]': recipient.name ?? '',
            'recipients[$i][email]': recipient.email,
          });
        } else if (recipient is String) {
          recipientFields.addAll({
            'recipients[$i][name]': '',
            'recipients[$i][email]': recipient,
          });
        }
      }
    } else if (recipients is String || recipients is MailRecipient) {
      recipientFields.addAll(_appendSingleRecipient(recipients));
    }
    return recipientFields;
  }

  Map<String, String> _appendSingleRecipient(dynamic recipient) {
    if (recipient is MailRecipient) {
      return {
        'recipients[0][name]': recipient.name ?? '',
        'recipients[0][email]': recipient.email,
      };
    } else if (recipient is String) {
      return {
        'recipients[0][name]': '',
        'recipients[0][email]': recipient,
      };
    } else {
      return {};
    }
  }

  Map<String, String> appendTemplate(MailTemplate? template) {
    if (template == null) return {};
    return {
      'template[id]': template.id,
      ...template.variables.map((key, value) =>
          MapEntry('template[variables][$key]', value))
    };
  }

  Map<String, String> appendCalendarEvent(CalendarEventOptions? event) {
    if (event == null) return {};

    return {
      // Essential event details
      'calendarEvent[title]': event.title,
      'calendarEvent[startDate]': event.startDate.toIso8601String(),
      'calendarEvent[endDate]': event.endDate.toIso8601String(),
      // Optional details (included conditionally)
      if (event.description != null) 'calendarEvent[description]': event.description!,
      if (event.location != null) 'calendarEvent[location]': event.location!,
      if (event.url != null) 'calendarEvent[url]': event.url!,
      if (event.organizer != null) 'calendarEvent[organizer]': event.organizer!,
    };
  }

  Map<String, String> appendResponseAddress(ResponseAddress? address) {
    if (address == null) return {};

    return {
      'responseAddress': address.toString(),
    };
  }


}