<p align="center">
<img src="readme-resources/app-icon.png" alt="DTrip">
</p>

<h1 align="center">DTrip</h1>

<p align="center">
<a href="https://testflight.apple.com/join/D1WKnKdA"><img src="readme-resources/en_badge_testflight_323.png" width="20%" height="20%"  alt="TestFlight"/></a>
</p>
<p align="center">
<a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift"/></a>
<img src="https://img.shields.io/badge/Platform-iOS%2011.0+-lightgrey.svg" alt="Platform: iOS">
</p>

## Building the code

1. Clone the repository.

    ```shell
    git clone https://github.com/d-trip/dtrip-ios.git
    ```

2. Install dependencies

    ```shell
    gem install bundler
    bundle install
    pod install
    carthage bootstrap --platform iOS
    ```

3. Open DTrip.xcworkspace
4. Run DTrip scheme.

## Roadmap

- [ ] Searching posts or users
- [ ] Comments reading
- [ ] User authorisation
- [ ] Voting, comments writing
- [ ] Post's redactor

## Contributing

Contributions are absolutely welcome!

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request.
