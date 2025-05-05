// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `This is your activity summary`
  String get summary {
    return Intl.message(
      'This is your activity summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Meditations completed:`
  String get meditationCompleted {
    return Intl.message(
      'Meditations completed:',
      name: 'meditationCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Select a meditation`
  String get meditationSelect {
    return Intl.message(
      'Select a meditation',
      name: 'meditationSelect',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Updated summary`
  String get updatedSummary {
    return Intl.message(
      'Updated summary',
      name: 'updatedSummary',
      desc: '',
      args: [],
    );
  }

  /// `Meditation completed!`
  String get medCompleted {
    return Intl.message(
      'Meditation completed!',
      name: 'medCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Error playing audio`
  String get errorAudio {
    return Intl.message(
      'Error playing audio',
      name: 'errorAudio',
      desc: '',
      args: [],
    );
  }

  /// `Error al registrar la meditación completada:`
  String get errorMedCompleted {
    return Intl.message(
      'Error al registrar la meditación completada:',
      name: 'errorMedCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Error recording completed meditation`
  String get errorRegisterProgress {
    return Intl.message(
      'Error recording completed meditation',
      name: 'errorRegisterProgress',
      desc: '',
      args: [],
    );
  }

  /// `Total progress:`
  String get totalProgress {
    return Intl.message(
      'Total progress:',
      name: 'totalProgress',
      desc: '',
      args: [],
    );
  }

  /// `completed`
  String get completed {
    return Intl.message(
      'completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Explore meditations`
  String get explore {
    return Intl.message(
      'Explore meditations',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Check progress`
  String get progress {
    return Intl.message(
      'Check progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Evolution`
  String get evolution {
    return Intl.message(
      'Evolution',
      name: 'evolution',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme`
  String get selectTheme {
    return Intl.message(
      'Select Theme',
      name: 'selectTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightTheme {
    return Intl.message(
      'Light',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get darkTheme {
    return Intl.message(
      'Dark',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Notifications enabled`
  String get notificationsEnabledMessage {
    return Intl.message(
      'Notifications enabled',
      name: 'notificationsEnabledMessage',
      desc: '',
      args: [],
    );
  }

  /// `Notifications disabled`
  String get notificationsDisabledMessage {
    return Intl.message(
      'Notifications disabled',
      name: 'notificationsDisabledMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviewsTitle {
    return Intl.message(
      'Reviews',
      name: 'reviewsTitle',
      desc: '',
      args: [],
    );
  }

  /// `This meditation has no rating yet`
  String get noReviewsYet {
    return Intl.message(
      'This meditation has no rating yet',
      name: 'noReviewsYet',
      desc: '',
      args: [],
    );
  }

  /// `Error loading reviews`
  String get errorLoadingReviews {
    return Intl.message(
      'Error loading reviews',
      name: 'errorLoadingReviews',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your opinion!`
  String get opinionThanks {
    return Intl.message(
      'Thanks for your opinion!',
      name: 'opinionThanks',
      desc: '',
      args: [],
    );
  }

  /// `Add a review`
  String get addReview {
    return Intl.message(
      'Add a review',
      name: 'addReview',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Comment on the meditation you have done:`
  String get comment {
    return Intl.message(
      'Comment on the meditation you have done:',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Administrator panel`
  String get adminView {
    return Intl.message(
      'Administrator panel',
      name: 'adminView',
      desc: '',
      args: [],
    );
  }

  /// `Review deleted.`
  String get reviewDeleted {
    return Intl.message(
      'Review deleted.',
      name: 'reviewDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Review saved.`
  String get reviewSaved {
    return Intl.message(
      'Review saved.',
      name: 'reviewSaved',
      desc: '',
      args: [],
    );
  }

  /// `Error responding:`
  String get errorAnswer {
    return Intl.message(
      'Error responding:',
      name: 'errorAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Reply to review`
  String get answerReview {
    return Intl.message(
      'Reply to review',
      name: 'answerReview',
      desc: '',
      args: [],
    );
  }

  /// `Your answer`
  String get yourAnswer {
    return Intl.message(
      'Your answer',
      name: 'yourAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `User deleted.`
  String get userDeleted {
    return Intl.message(
      'User deleted.',
      name: 'userDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Undated`
  String get undated {
    return Intl.message(
      'Undated',
      name: 'undated',
      desc: '',
      args: [],
    );
  }

  /// `Answer:`
  String get answer {
    return Intl.message(
      'Answer:',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Answer saved.`
  String get answerSaved {
    return Intl.message(
      'Answer saved.',
      name: 'answerSaved',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete review?`
  String get deleteReview {
    return Intl.message(
      'Delete review?',
      name: 'deleteReview',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone.`
  String get actionUndone {
    return Intl.message(
      'This action cannot be undone.',
      name: 'actionUndone',
      desc: '',
      args: [],
    );
  }

  /// `User management`
  String get userManagement {
    return Intl.message(
      'User management',
      name: 'userManagement',
      desc: '',
      args: [],
    );
  }

  /// `Unknown name`
  String get unknownName {
    return Intl.message(
      'Unknown name',
      name: 'unknownName',
      desc: '',
      args: [],
    );
  }

  /// `No email`
  String get noEmail {
    return Intl.message(
      'No email',
      name: 'noEmail',
      desc: '',
      args: [],
    );
  }

  /// `Delete user?`
  String get deleteUser {
    return Intl.message(
      'Delete user?',
      name: 'deleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this user? This action is irreversible.`
  String get actionIrreversible {
    return Intl.message(
      'Are you sure you want to delete this user? This action is irreversible.',
      name: 'actionIrreversible',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
