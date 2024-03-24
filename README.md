# kicko

![Flutter CI](https://github.com/keskinm/kicko/actions/workflows/flutter_ci.yml/badge.svg)


## Format files

`dart format lib test`

## Install dependencies 

`pub get`

## Tests 

`flutter test test/ `

## Run in local 

`flutter run -d chrome`

To change server target env:

`flutter run -d chrome --dart-define=API_TARGET_ENV=prod (or env)`

## Deploy

`flutter build web`
`cd build/web`
`python3 -m http.server 8000`

## Deploy with Netifly 

- Simply specify `flutter build web` as build command
- Specify `build/web` as publish directory
- Enable `Flutter SDK` in integration page