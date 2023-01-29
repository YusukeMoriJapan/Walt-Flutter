pushd android
flutter build apk
./gradlew app:assembleAndroidTest
# androidでintegration testを実行
./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart
popd

# firebase test android runコマンドのドキュメント
# https://cloud.google.com/sdk/gcloud/reference/firebase/test/android/run

# --app: apkパスを指定

# --test: instrumentation test用のapkパスを指定

# --use-orchestrator: Android Test Orchestratorを使用する
# https://android.suzu-sd.com/2020/05/testorch_de_dokuritsu_wo_tsukuru/

# --timeout: instrumentationテストのタイムアウト時間を指定

# --device-ids, --os--version-ids, --locales: テストメトリックスを定義する。指定された条件から自動的にfirebaseが全てのパターンを網羅するテストを実行する

# Firebase Test Labで利用できるデバイスidリストは以下コマンドで取得可能
# gcloud firebase test android models list

gcloud firebase test android run --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --device-ids=blueline \
  --os-version-ids=30 \
  --locales=ja_JP \
  --use-orchestrator \
  --timeout 3m

# テスト結果をGoogle Cloud Storage上に保存したい場合は下記オプションも追加する
#  --results-bucket=gs://integration_results_walt \
#  --results-dir=tests/firebase
