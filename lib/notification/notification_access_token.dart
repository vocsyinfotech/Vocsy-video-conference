import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope = 'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "cc-video-conference",
          "private_key_id": "08107cfce21abc240979723ba6233db36883c727",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCswkU/TXkBvynj\n7nHedIVhDIefqS+5mOB00i1tFhmShsLZUuSkkMfu8RCuf2z1t3NTGYw2WlVXCg5k\n6X87rnDcWOx7S/6h2BFQdEyCWbacLgxIseuGpLvHkXE0CgMTtDhBzUoX8Tlhyv+Q\nRHmI3u4uCp9djkpXcnkhQoIPob4DCVgEjEBMBQ8zxp8ZUaP4HVxmQqTiuB18na6x\nvCynKENP9UqrzZIx0MmiN527nHqq+eFDvqLHILAsxAsGDRUYPZxodKvPINzs6v6L\ngOjgDplg5pT2wiVy+lvnc5Xxroxvx/9+6cskrxIcwCSAwkTNDs4o0wKeZ7S0nllk\nQ41kF2j9AgMBAAECggEAGvQ9RqOpR279M7KucdAJ8WWO5t0dn55Xwuekrm+eHMue\n12EvYEe1519q7rbd7WEqgqLVSrOsZftL2fhztqrrBqNvKMuSFnag45se8Xra2sz1\nHgXNzWuitVVJbXOfHZy8PElcj+tokbamShWM8CB21ph8sJBJ+WaDD1U8+ABl0OY1\nm2R/essGndeDRO8e0Wqpbd54cU8NkWXGRqlqdrYr5SfAkIBgaoWanx7/vubFGycX\nhsXOZ5MenilaHnPg9P957ckipxUuADRgyQYyh/GlRY3KkpGljqRtRJeDG0ko1f6l\nIttR9vLSzBN06rvvvVr7S8d4qkvURlOS7/bUfj7mVwKBgQDwOFfQspdfMCdUJwBv\nj4NRQhyxeigN0vj7j0pxsAMhqjU51f3iUqYnn78PPPT5Cgi2ilPDYDHxvz6GwKnW\nEVNH3juVOZeTE2Ff3zyBkDmRV78QboKRTXkNv7pExJ7DHOxTexw3CMf9v2Qs3O34\nQaXLKGKE5tWdLbe8ZcZsanOGawKBgQC4G3eOpCTTcIoOF9MFEXnc/pJCHH6MFwjw\ny9n9oB2XxMuzvndoMgk8LFUs5LKUnuFEv6sPq7o7201actyoXKICuSOs554iHJvM\n8lGxODOr4oFQwa0SV8ljD1tJ1kzXuEa8evbY0pj8O3QrU6RNC9yQFTier/ORnuoW\nMZbmieKYNwKBgQDk4+rY0rLlYk63IoqJwmdPz/zjJxBvS60ulbRLa3kwZKxetYY6\nVqI3c0Fr1ZteiK8Qr/FsYoZ0YNPFNmMdtFh0TE7du4iv/XF1FpLiqXgRA1js4T/M\nD9Pew+dKi0bzhuWwDcgusFFPeUSMct7VBEhjsdFd7U1xfRRrkVZmC3CUjQKBgC49\nV83PlCA2x7W6bhl7xiunFHzeQzpUHr67tEhrCoOvvamrULoutvsR92KLHf8N2G43\n5XLOIrwd3FO3PYxbl6UvcrJeiezvWoIi6jmkb/XfsbLiseFFgyMKHFdzJ2GWus1j\n5NOYMSxIkmi/XSisrfzSF6Jjdr1AOHLSiZ/lSbAJAoGAEoeAPXQlH61NtYYgnVEq\n24pUfNhQ09WI654aPgGKPmfo4ns3lOC2THKOdm0NXvdIOWzYXRTiSanQjJzNbbST\nRx70OQ8s52534kVU3+fY7Beo1YWDoBxzhpmY3SwX79WBL2V6jFlhwoiKzKmja+0o\nh2kWgZYIulbm6jvVR8ymT1g=\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-fbsvc@cc-video-conference.iam.gserviceaccount.com",
          "client_id": "111961658962820969103",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40cc-video-conference.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com",
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
