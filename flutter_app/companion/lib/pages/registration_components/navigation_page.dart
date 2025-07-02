import 'package:companion/pages/registration_components/finish_page.dart';
import 'package:companion/pages/registration_components/height_selection.dart';
import 'package:companion/pages/registration_components/weight_selection.dart';
import 'package:flutter/material.dart';
import 'package:companion/pages/registration_components/classes/registrationdata.dart';
import 'package:companion/pages/registration_components/start_page.dart';
import 'package:companion/pages/registration_components/personaI_info_page.dart';
import 'package:companion/pages/registration_components/bodytype_page.dart';
import 'package:companion/pages/registration_components/age_selection.dart';
import 'package:companion/pages/registration_components/experience_page.dart';
import 'package:companion/pages/registration_components/goal_page.dart';
import 'package:companion/pages/registration_components/frequency_page.dart';
import 'package:companion/pages/registration_components/pain_page.dart';

enum Page {
  StartPage,
  PersonalInfo,
  BodyType,
  AgeSelection,
  WeightSelection,
  HeightSelection,
  Experience,
  Goals,
  TrainingFrequency,
  PainPoints,
  FinishPage,
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final PageController _pageController = PageController(initialPage: 0);
  final RegistrationData _registrationData = RegistrationData();

  void _navigateToNextPage(Page currentPage) {
    switch (currentPage) {
      case Page.StartPage:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.PersonalInfo:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.BodyType:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.AgeSelection:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.WeightSelection:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.HeightSelection:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.Experience:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.Goals:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.TrainingFrequency:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.PainPoints:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.FinishPage:
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _navigateToPreviousPage(Page currentPage) {
    switch (currentPage) {
      case Page.StartPage:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.PersonalInfo:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.BodyType:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.AgeSelection:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.WeightSelection:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.HeightSelection:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.Experience:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.Goals:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.TrainingFrequency:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.PainPoints:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        break;
      case Page.FinishPage:
        _pageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          StartPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.PersonalInfo),
          ),
          PersonalInfo(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.BodyType),
            naviagteToPreviousPage: () =>
                _navigateToPreviousPage(Page.StartPage),
          ),
          BodyType(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.AgeSelection),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.PersonalInfo),
          ),
          AgeSelectionPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.WeightSelection),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.BodyType),
          ),
          WeightSelectionPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.HeightSelection),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.AgeSelection),
          ),
          HeightSelectionPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.Experience),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.WeightSelection),
          ),
          ExperiencePage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.Goals),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.HeightSelection),
          ),
          GoalPage(
            registrationData: _registrationData,
            navigateToNextPage: () =>
                _navigateToNextPage(Page.TrainingFrequency),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.Experience),
          ),
          TrainingFrequencyPage(
            registrationData: _registrationData,
            navigateToNextPage: () =>
                _navigateToNextPage(Page.TrainingFrequency),
            navigateToPreviousPage: () => _navigateToPreviousPage(Page.Goals),
          ),
          PainPointPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.FinishPage),
            navigateToPreviousPage: () =>
                _navigateToPreviousPage(Page.TrainingFrequency),
          ),
          FinishPage(
            registrationData: _registrationData,
            navigateToNextPage: () => _navigateToNextPage(Page.FinishPage),
          ),
        ],
      ),
    );
  }
}
