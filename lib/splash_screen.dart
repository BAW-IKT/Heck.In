import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hedge_profiler_flutter/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  final bool darkMode;

  const SplashScreen({
    super.key,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    Color textColor = darkMode == true ? MyColors.white80 : MyColors.black;
    Color acceptColor = MyColors.greenDark;
    Color backgroundColor = darkMode == true ? MyColors.sideBarBackground : MyColors.white;

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'heckin@baw.at',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Heckin App Request',
      }),
    );

    final Uri websiteLaunchUri = Uri(
      scheme: "https",
      path: "www.baw.at",
    );

    TextSpan getMailLinkText() {
      return TextSpan(
          text: "heckin@baw.at",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(emailLaunchUri);
            },
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MyColors.blueDark,
          ));
    }

    TextSpan getBawWebsiteLinkText() {
      return TextSpan(
          text: "baw.at",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchUrl(websiteLaunchUri);
            },
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: MyColors.blueDark,
          ));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60),
                Image.asset(
                  'data/lsw_logo.png',
                ),
                const SizedBox(height: 60),
                Text(
                  languageCode == "de"
                      ? """Herzlich Willkommen bei Heck.in, Ihrer App zur Bewertung von Ökosystemleistungen von Hecken!"""
                      : """Welcome to Heck.in, your app for assessing the ecosystem services of hedgerows!""",
                  style: TextStyle(fontSize: 24, color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Text(
                  languageCode == "de"
                      ? """Wir freuen uns, Sie an Bord zu haben. Mit dieser Anwendung können Sie ganz einfach die vielfältigen Leistungen einer Hecke bewerten."""
                      : """We are delighted to have you on board. With this application you can easily evaluate the various services of a hedge.""",
                  style: TextStyle(fontSize: 16, color: textColor),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Text(
                  languageCode == "de"
                      ? """Um Ihnen den Einstieg zu erleichtern, finden Sie rechts oben die Kategorien, zwischen denen Sie bequem wechseln können. Außerdem stehen Ihnen informative Hinweise zur Verfügung – klicken Sie dazu einfach auf die Info-Buttons neben den abgefragten Indikatoren. Diese geben Ihnen Anweisungen zur Aufnahme der jeweiligen Daten. Beachten Sie bitte, dass einige Indikatoren nicht vor Ort erfasst werden, sondern online auf einer Webseite aufgenommen werden müssen. Auch hierzu finden Sie entsprechende Verweise im Infobereich des Indikators. Sobald Sie alle Daten vollständig erfasst haben, steht Ihnen das Ergebnis zur Verfügung."""
                      : """To make it easier for you to get started, you will find the categories in the top right-hand corner, which you can easily switch between. There are also informative tips available to you - simply click on the info buttons next to the requested indicators. These give you instructions on how to record the respective data. Please note that some indicators are not recorded on site, but must be recorded online on a website. You will also find corresponding links for this when clicking on the info button. As soon as you have recorded all the data, the results will be available to you.""",
                  style: TextStyle(fontSize: 16, color: textColor),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 16, color: textColor),
                      children: [
                        TextSpan(
                          text: languageCode == "de"
                              ? "Support und Hilfe: "
                              : "Support and help: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: languageCode == "de"
                              ? "Bei Fragen oder Problemen stehen wir Ihnen gerne zur Verfügung. Kontaktieren Sie unseren Support unter "
                              : "If you have any questions or problems, we will be happy to help you. Contact our support team at ",
                        ),
                        getMailLinkText(),
                        const TextSpan(text: ".\n\n"),
                        TextSpan(
                          text: languageCode == "de"
                              ? "Feedback: "
                              : "Feedback: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: languageCode == "de"
                                ? "Wir schätzen Ihr Feedback, um die App kontinuierlich zu verbessern. Teilen Sie uns Ihre Anregungen und Vorschläge gerne unter "
                                : "We value your feedback in order to constantly improve the app. Please share your suggestions and suggestions to us at "),
                        getMailLinkText(),
                        TextSpan(
                            text: languageCode == "de" ? " mit.\n\n" : ".\n\n"),
                        TextSpan(
                          text: languageCode == "de"
                              ? "Datensammlung: "
                              : "Data collection: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: languageCode == "de"
                                ? "Mit Abschluss der Bewertung wird das Ergebnis anonymisiert an einen Server des österreichischen Bundesamts für Wasserwirtschaft ("
                                : "Upon completion of the assessment, the result is transmitted anonymously to a server of the Austrian Federal Office for Water Management ("),
                        getBawWebsiteLinkText(),
                        TextSpan(
                            text: languageCode == "de"
                                ? ") übermittelt. Es werden keinerlei persönliche Daten von Ihnen gespeichert, die fachlichen Daten werden zusammengeführt und sollen in der Zukunft einen Überblick über den Zustand von Hecken in verschiedensten Regionen ermöglichen. Sollten Sie mit dieser Übermittlung nicht einverstanden sein, kann vor dem Abschluss der Bewertung die entsprechende Option aktiv abgewählt werden."
                                : "). No personal data of yours will be stored, the technical data will be merged and should provide an overview of the condition of hedges in various regions in the future. If you do not agree to this transmission, you can actively deselect the corresponding option before completing the assessment."),
                      ]),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(languageCode == "de" ? "Ablehnen" : "Decline",
                          style: const TextStyle(color: MyColors.grey)),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("first_time_launch", "false");
                        prefs.setString("data_consent", "false");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const WebViewPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: Text(
                        languageCode == "de" ? "Akzeptieren" : "Accept",
                        style: TextStyle(color: acceptColor),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("first_time_launch", "false");
                        prefs.setString("data_consent", "true");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const WebViewPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
