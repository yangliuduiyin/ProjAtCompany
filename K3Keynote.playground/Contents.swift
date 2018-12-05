import UIKit

var str = "Hello, playground"

// MARK: - 2018-12-05
/**
 1. 静态库和动态库的使用注意事项:
   * 如果静态库中有category类，则在使用静态库的项目配置中Other Linker Flags需要添加参数-ObjC或者-all_load。
   * 如果创建的framework类中使用了.tbd，则需要在实际项目中导入.tbd动态库。
 */
