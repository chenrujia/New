xcodebuild -workspace YouFeel.xcworkspace -scheme YouFeel archive -archivePath ./build/YouFeel.xcarchive
&& \rm -rf ./build/YouFeel.ipa
&& \xcodebuild -exportArchive -exportFormat ipa -archivePath build/YouFeel.xcarchive -exportPath build/YouFeel.ipa
&& \fir publish build/YouFeel.ipa -T b703686f3cecef10acb16da566571d99