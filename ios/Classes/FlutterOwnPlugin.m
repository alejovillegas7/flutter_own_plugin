#import "FlutterOwnPlugin.h"
#if __has_include(<flutter_own_plugin/flutter_own_plugin-Swift.h>)
#import <flutter_own_plugin/flutter_own_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_own_plugin-Swift.h"
#endif

@implementation FlutterOwnPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterOwnPlugin registerWithRegistrar:registrar];
}
@end
