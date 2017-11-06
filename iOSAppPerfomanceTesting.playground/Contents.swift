//: Playground - noun: a place where people can play

import UIKit

var str = "iOS App 性能优化"

// https://mp.weixin.qq.com/s/e-UDC_j9LZX5_YDG4s0-gg

// MARK: - iOS App 性能检测方案
/**
 * 1.Instruments
 * 2.使用第三方SDK
 * 3.自动添加检测代码
 */

// MARK: - 3.自动添加检测代码
// 3.1 AOP:
/**
 采用切面的方式，统一的为大量的类增加检测代码。具体做法是写一个类作为UIViewController的分类，增加几个方法如XXXviewdidload ， XXXviewdidappear等，用swizzle替换一些对应的生命周期方法，塞入一些统计的代码。示例代码如下：
 #import "UIViewController+APMUIViewController.h"
 #import <objc/runtime.h>
 /**
 *
 埋点：直接在想要的地方埋上你需要计算的性能指标、开始和结束时间的采集点，这种方式更加灵活，只关心自己关心的页面。
 AOP是“大锅饭”，量大管饱，一次性为大量的类增加了检测代码，对原有代码侵入性也较小；埋点是“开小灶”，随心所欲，但是分散的代码管理起来也是一个问题。
 */
 // UIViewController + APMUIViewController.m
 @implementation UIViewController (APMUIViewController)
 
 + (void)load {
 Class clz = [self class];
 
 SEL oldSel = @selector(viewDidLoad);
 SEL newSel = @selector(newViewDidLoad);
 
 Method originalMethod = class_getInstanceMethod(clz, oldSel);
 Method swizzMethod = class_getInstanceMethod(clz, newSel);
 
 BOOL didAddMethod = class_addMethod(clz, oldSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
 
 if (didAddMethod) {
 class_replaceMethod(clz, oldSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
 }else {
 method_exchangeImplementations(originalMethod, swizzMethod);
 }
 
 }
 
 - (void)newViewDidLoad {
 
 NSLog(@"start logging"); // 获取性能的函数
 [self viewDidLoad]; // 原文为[super viewDidLoad];报错!!!
 NSLog(@"end logging");
 
 }
 
 
 @end
 */

// 3.2 埋点:
/**
 直接在想要的地方埋上你需要计算的性能指标、开始和结束时间的采集点，这种方式更加灵活，只关心自己关心的页面。
 */

// MARK: - 启动时间检测:
/**
 * Launch页
 * main()
 * UIApplicationMain()
 * willFinishLaunchingWithOptions()
 * didFinishLaunchingWithOptions()
 * loadView()
 * viewDidLoad()
 * applicationDidBecomeActive()
 注意Launch页是先于main函数出来的，main函数就不说了，应用程序入口，里面调用了UIApplicationMain。当App从didFinishLaunchingWithOptions返回的时候，实际的UI立刻开始加载。这里的loadView是指你的app启动后加载的第一个view，这个view会在其controller的viewDidLoad执行完后被加载，这也是页面最终的初始化的时间。虽然UI已经被初始化，但是在applicationDidBecomeActive这个回调完成之前UI仍旧被阻塞着。
 
 *** 我们要计算的启动时间就是从main（）到applicationDidBecomeActive（）的时间，这个代码很好加，分别在main的最开始和applicationDidBecomeActive的最后一行增加时间获取的代码即可。
 *** 还有一种使用环境变量的方法，在Xcode的Edit scheme中增加DYLD_PRINT_STATISTICS这个环境变量
 */

// 启动时间优化: 参考: http://www.jianshu.com/p/65901441903e


// MARK: - 获取内存使用量
/**
 #import <mach/mach.h>
 #import <mach/task_info.h>
 
 - (unsigned long)memoryUsage
 {
 struct task_basic_info info;
 mach_msg_type_number_t size = sizeof(info);
 kern_return_t kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
 if (kr != KERN_SUCCESS) {
 return -1;
 }
 unsigned long memorySize = info.resident_size >> 10;//10-KB   20-MB
 
 return memorySize;
 } // 返回的单位是KB,如果想要MB的话把10改为20.
 */
/**
 增加App的内存占用的操作有创建对象，定义变量，调用函数的堆栈，多线程，密集的网络请求或长链接等等，我们可以对一些大的对象、view进行复用，懒加载资源，及时清理不再使用的资源（ARC下这个问题没那么严重）。
 */


// MARK: - CPU使用率:
// 示例代码:
/**
 - (float)cpu_usage
 {
 kern_return_t            kr = { 0 };
 task_info_data_t        tinfo = { 0 };
 mach_msg_type_number_t    task_info_count = TASK_INFO_MAX;
 
 kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
 if ( KERN_SUCCESS != kr )
 return 0.0f;
 
 task_basic_info_t        basic_info = { 0 };
 thread_array_t            thread_list = { 0 };
 mach_msg_type_number_t    thread_count = { 0 };
 
 thread_info_data_t        thinfo = { 0 };
 thread_basic_info_t        basic_info_th = { 0 };
 
 basic_info = (task_basic_info_t)tinfo;    // get threads in the task
 kr = task_threads( mach_task_self(), &thread_list, &thread_count );
 if ( KERN_SUCCESS != kr )
 return 0.0f;
 long    tot_sec = 0;
 long    tot_usec = 0;
 float    tot_cpu = 0;
 for ( int i = 0; i < thread_count; i++ )
 {
 mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
 
 kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
 if ( KERN_SUCCESS != kr )
 return 0.0f;
 
 basic_info_th = (thread_basic_info_t)thinfo;
 if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
 {
 tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
 tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
 tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
 }
 }
 
 kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
 if ( KERN_SUCCESS != kr )
 return 0.0f;
 return tot_cpu * 100.; // CPU 占用百分比}
 */

/**
 影响CPU使用情况的主要是计算密集型的操作，比如动画、布局计算和Autolayout、文本的计算和渲染、图片的解码和绘制。比较常见的一种优化方式就是缓存tableview的cell高度，避免每次计算。想要降低CPU的使用率就要尽量避免大量的计算，能缓存的缓存，不得不计算的，看看是否可以使用一些算法进行优化，降低时间复杂度。
 */

// MARK: - 耗电功率
/**
 把耗电功率放到最后，是因为耗电功率是个比较综合的指标，影响因素很多。跟性能相关的，密集的网络请求，长链接，密集的CPU操作（比如大量的复杂计算）都会使耗电功率增加。此外，耗电量还会被很多其他因素影响，比如用户在不同光线下使用，iPhone会自动调整屏幕亮度，就会导致耗电量不同；网络状况（流畅的Wi-Fi还是信号不好的3G）
 
 由于耗电量的影响因素太多，统计出来并不能精准的反应你的APP的性能，所以笔者认为，一般的APP不必把耗电量当作一个优化指标，只要把可能影响耗电量的、可优化的部分尽量优化即可，比如网络请求和CPU操作。毕竟对于大多数APP来说，还谈不上耗电太多的问题，需要重点考虑耗电问题的应该是像微信这种用户重度依赖（人均使用时长）或者是视频类应用这种耗电大户。不是说不优化耗电量，而是优化了其他的，耗电量自然就会减少了，单纯从这个值来讲不好检测。
 
 首先测量耗电量的时候不能用模拟器，模拟器下得到的电量值是负数，也不能用真机连着电脑debug，因为这个过程本身就在给手机充电。正确的做法是在手机上设置Settings→developer→logging on your device→enable energy logging再开始记录，一段时间以后再stop，再用手机连接到电脑的instrument上，import log记录进行分析。
 
 还有就是在代码中获取电量值，在特定场景之前、之后检查电量使用情况，计算差值。电量的计算要有一定的时间长度才可以，不可能是一个函数的前后就有能看得见的变化（要是有这样的函数也太恐怖了）。
 */

