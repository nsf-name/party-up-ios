# Party UP! (iOS Edition)
Simple iOS port of [Party UP!](https://github.com/9001/party-up), a copyparty upload client.

Highly experimental software. v1.0 is reached when uploading (`up2k` style ideally) works, which would be feature-parity with the Android app. The goal is that whatever exists in the Android version exists in this version too (wherever that's possible).

## Building
On a Mac, run the following:
```
$ git clone https://github.com/nsf-name/party-up-ios
$ xcodegen generate
$ make # or just "make", or "make release"
```
After a build, run `make clean`. This app will be on the App Store at some point; unless you have an Apple Developer account and a license, you'll be unable to run this on devices you don't own. 

## License
This app is licensed under the MIT license, just like the original Android version.
