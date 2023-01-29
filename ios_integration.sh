output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="16.2"

# Pass --simulator if building for the simulator.
flutter build ios integration_test/sample_test.dart --release

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd

gcloud firebase test ios run --test "build/ios_integ/Build/Products/ios_tests.zip" \
  --device model=iphone8,version=$dev_target,locale=ja_JP,orientation=portrait \
  --timeout 3m

# テスト結果をGoogle Cloud Storage上に保存したい場合は下記オプションも追加する
#  --results-bucket=gs://integration_results_walt \
#  --results-dir=tests/firebase
