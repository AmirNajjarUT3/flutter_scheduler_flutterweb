# Appointment Scheduler FlutterWeb

An appointment scheduler web application built using Flutter.

## Database Functionalities
- Get availabilities
- Create availabilities
- Delete availabilities
- Create reservations
- Delete reservations

## About the Reservation Reference
In order to permit a certain user to register for multiple time slots using the same email. A reference ID of **5 uppercase letters** has been addeed to a reservation.

## Futher Suggestions (AI)
One possible AI implementation is to have an AI model learning the users' behaviors and the most common time slots chosen given a specific timezone. The AI model would then suggest those time slots automatically to users.

## Web Application Link
The web application is hosted on https://appointment-sched-flutterweb.web.app

## Local Installation
In case the web app is non-functional or to install locally, please follow [this link](https://docs.flutter.dev/get-started/install) to install Flutter. After having installed Flutter, run `main.dart` to launch the web application.

## Building the application
To build the application, execute the following command:
```
flutter build web
```