# Medusa Admin Mobile
Manage your [MedusaJs](https://medusajs.com/) ecommerce store from your mobile phone.

![Alt text](/screenshots/Medusa-Admin-Mobile-Screenshot.png?raw=true)


## Getting Started
Medusa Admin Mobile is built with [Flutter](https://flutter.dev/) with the aim to ease managing ecommerce store that are built using [MedusaJs](https://medusajs.com/), it's available for iOS and Android, it's still in beta so expect to see some bugs/unimplemented features.


##  Installation
Add [Flutter](https://docs.flutter.dev/get-started/install) to your machine

Open this project folder with Terminal/CMD and run the following command
```
flutter packages get
```
then 
```
flutter pub run build_runner build
```
then change the baseUrl (found in "lib/core/utils/strings.dart" ) to your backend URL

- To run the app on Android just run the following command in the root directory of the project:
```
flutter run
```
- or to build apk 
```
flutter build apk
```

- To run the app on iOS just run the following command in the root directory of the project: (macOS only)
```
flutter run
```
- or to build ipa
```
flutter build ipa
```

## Features
- [x] View and update store settings ( Regions, Return reasons, sales channels etc)
- [x] View and add new products
- [x] View, add and update collection groups
- [x] View, add and update customers and customer groups
- [x] View, add and update discounts
- [x] View and add/update pricing list
- [x] View and add/update gift cards
- [x] Update order items
- [x] Add and update draft order
- [x] App settings
- [x] Support for light/dark mode
      

## Contributing
We welcome contributions from the community to make Medusa Admin even better. If you want to contribute, please follow these steps:

1. Fork the repository on GitHub.
2. Create a new branch and make your changes.
3. Submit a pull request, explaining the purpose of your changes.


## License

All the code available under the MIT license. See [LICENSE](LICENSE).




    
