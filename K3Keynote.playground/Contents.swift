import UIKit

var str = "Hello, KeyNote@3K.com"

// MARK: - 2018-12-05
/**
 1. 静态库和动态库的使用注意事项:
   * 如果静态库中有category类，则在使用静态库的项目配置中Other Linker Flags需要添加参数-ObjC或者-all_load。
   * 如果创建的framework类中使用了.tbd，则需要在实际项目中导入.tbd动态库。
 */

// MARK: - 2018-12-20
/**
 * 1. Swift中添加警⚠️标志:
 a.arget -> New Run Script Phase
 b.输入如下脚本:
 TAGS="TODO:|FIXME:"
 echo "searching ${SRCROOT} for ${TAGS}"
 find "${SRCROOT}" /( -name "*.swift" /) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).(此处及后面两个字符多余)//*/$" | perl -p -e "s/($TAGS)/ warning: /$1/"
 */
*/


/**
 * 2. Moya的使用
 * 3. HandyJSON的使用
 */
 
// MARK: - 2018-12-21
/**
 * 1. 使用fastlane快速上传ipa文件到App Store的命令:
    fastlane deliver --ipa /Users/admin/Downloads/qq下载/KKKDATA\ 2018-11-21\ 21-29-50/KKKDATA.ipa    --skip_screenshots --skip_metadata
 */

// MARK: - 2018-12-29
// refer: https://juejin.im/entry/593f559c128fe1006afbb215
// refer: https://cloud.tencent.com/developer/article/1331247 FIX issue！
/**
 * 创建Cocoapods私有库:
 * 1. 在GitHub/GitLab上创建私有spec库: YZMSpecs https://gitee.com/yangliuduiyin/YZMSpecs
 * 2. 将1中的spec库添加到本地: pod repo add YZMSpecs https://gitee.com/yangliuduiyin/YZMSpecs
      添加成功后即可前往本地文件夹查看: open ~/.cocoapods/repos
 * 3. 创建私有项目:
      3.1 在本地创建代码库: pod create lib YZMToolKit
      3.2 依次回答几个问题
      3.3 生成一个项目YZMToolKit,如图:
      3.4 YZMToolKit里面有两个文件夹:
            * Assets: 存放图片资源等
            * Classes: 存放源码,默认会有一个ReplaceMe.m文件
       我们只需要把要上传的代码放入Classes文件即可,如果需要查看更改后demo效果,在Example中pod update即可更新修改的文件.
      3.5 在github或gitlab上创建新的pod项目: https://gitee.com/yangliuduiyin/YZMToolKit
      3.6 进入YZMToolKit项目(项目根目录),修改spec文件,如图:
      3.7 执行命令: pod lib lint --allow-warnings
      3.8 继续执行如下命令
          a. git remote add origin https://gitee.com/yangliuduiyin/YZMToolKit.git//这里是你需要pod的项目地址,不是spec私有库的地址哦!!!!!
          b. git add .
          c. git commit -m "init spec"
          d. git push origin master
          //注意:如果你创建项目的时候生成了README或者license文件,那么这里你push的时候可能会push不了,这里的话可以用
          git push origin master -f 强制提交,会覆盖之前的文件
      3.9 为pod项目添加tag:
          git tag -m "version_description" 0.1.0
          git push --tags
      3.10 最后一步,将你的spec文件push到私有库进行管理,可以用pod repo 命令查看你的私有库
          pod repo push YZMSpecs YZMToolKit.podspec (推送到本地和远程)
   4.进行私有库的测试:
    podfile:
    source 'https://github.com/CocoaPods/Specs.git'
    source 'https://gitee.com/yangliuduiyin/YZMSpecs.git'
    target 'DEMOYU' do
    # Pods for DEMOYU
    pod 'FMDB'
    pod 'LCLSDK'     #0.1.0
    pod 'YZMToolKit' #0.1.1
 
   5.私有库的版本更新:
     a.私有项目代码更新
     b.podspec文件更新
     c.执行3.8将项目推送的远程
     d.推送tag,与b中的版本号一致
     e.执行3.10
     f.更新使用私有库的项目:pod update
 */


// MARK: - 2019_01_14
/**
 * 1. Valet: https://github.com/square/Valet
 * description: Valet lets you securely store data in the iOS, tvOS, watchOS, or macOS Keychain without knowing a thing about how the Keychain works.
 * 2.LocalAuthentication框架的使用(指纹/Face 🆔解锁):https://github.com/Ryasnoy/AppLocker
 * 3.WKWebView适配iPhone X及其以上设备时屏幕下方有间隙的问题:
    if #available(iOS 11.0, *) {
         webView.scrollView.contentInsetAdjustmentBehavior = .never;
    }
 * 4.腾讯Bugly的实现原理
 * 5.iOS符号表解析
 20190112--Socket--Kody老师链接：https://pan.baidu.com/s/1vQp1HESM-gORajYI2Cn80g 提取码：94dj 
 */


// MARK: - 2019_01_21
/**
 1. lipo 常用命令:
 * 查看所支持的架构信息: lipo -info lib1.a
 * 合并: lipo -create AlipayRsaLib-armv7.a AlipayRsaLib-armv7s.a AlipayRsaLib-i386.a -output AlipayRsaLib.a
 * 拆分: lipo AlipayRsaLib.a -thin armv7 -output AlipayRsaLib-armv7.a
 
 */
