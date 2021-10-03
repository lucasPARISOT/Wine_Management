import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:winemanagement/language_flag.dart';

class LanguageData {

  static final Map<String, List<String>> map = {
    'countries': countries,
    'locale': locale
  };

  static final List<String> jsonList = [
    'assets/translations/bg-BG.json',
    'assets/translations/zh-CN.json',
    'assets/translations/da-DK.json',
    'assets/translations/en-US.json',
    'assets/translations/fr-FR.json',
    'assets/translations/de-DE.json',
    'assets/translations/el-GR.json',
    'assets/translations/it-IT.json',
    'assets/translations/nl-NL.json',
    'assets/translations/pt-PT.json',
    'assets/translations/ru-RU.json',
    'assets/translations/es-ES.json',
    'assets/translations/sv-SE.json',
  ];

  static final List<String> countries = [
    'Bulgarian',
    'Chinese',
    'Danish',
    'English',
    'French',
    'German',
    'Greek',
    'Italian',
    'Netherlands',
    'Portuguese',
    'Russian',
    'Spanish',
    'Swedish',
  ];

  static final List<String> locale = [
    'BG',
    'CN',
    'DK',
    'EN',
    'FR',
    'DE',
    'GR',
    'IT',
    'NL',
    'PT',
    'RU',
    'ES',
    'SE',
  ];

  Future<List<LanguageFlag>> getSuggestions(String query) async {

    final List<LanguageFlag> listFlag = [];
    final List<LanguageFlag> presentLanguages = [];

    final List<dynamic> listData = [];
    for(int i=0; i< jsonList.length; i++){
      listData.add(await rootBundle.loadString(jsonList[i]));
    }

    final queryLower = query.toLowerCase();

    final List<dynamic> listJson = [];

    for(int i=0; i < listData.length; i++){
      listJson.add(jsonDecode(listData[i]));
    }

    final List<dynamic> listLanguagesTranslations = [];

    for(int i=0; i < listJson.length; i++){

      listLanguagesTranslations.add(listJson[i]['Bulgarian']);
      listLanguagesTranslations.add(listJson[i]['Chinese']);
      listLanguagesTranslations.add(listJson[i]['Danish']);
      listLanguagesTranslations.add(listJson[i]['English']);
      listLanguagesTranslations.add(listJson[i]['French']);
      listLanguagesTranslations.add(listJson[i]['German']);
      listLanguagesTranslations.add(listJson[i]['Greek']);
      listLanguagesTranslations.add(listJson[i]['Italian']);
      listLanguagesTranslations.add(listJson[i]['Netherlands']);
      listLanguagesTranslations.add(listJson[i]['Portuguese']);
      listLanguagesTranslations.add(listJson[i]['Russian']);
      listLanguagesTranslations.add(listJson[i]['Spanish']);
      listLanguagesTranslations.add(listJson[i]['Swedish']);

    }

    for(int j=0; j < listLanguagesTranslations.length-1; j++) {

      if (
        listLanguagesTranslations[j]
          .toLowerCase()
          .contains(queryLower)
      ) {

        final LanguageFlag languageFlag = LanguageFlag(
            language: countries[j%listData.length],
            locale: locale[j%listData.length]
        );

        if(presentLanguages.isEmpty) {
          presentLanguages.add(languageFlag);
          listFlag.add(languageFlag);
        }
        else {
          var isPresent = false;
          for(final element in presentLanguages) {
            if(element.language.contains(languageFlag.language)) {
              isPresent = true;
            }
          }
          if(!isPresent) {
            presentLanguages.add(languageFlag);
            listFlag.add(languageFlag);
          }
        }
      }
    }
    return listFlag;
  }
}