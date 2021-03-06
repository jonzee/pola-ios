#import "BPDeviceHelper.h"


@implementation BPDeviceHelper

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)deviceInfo {
    UIDevice *device = [UIDevice currentDevice];

    NSMutableString *deviceInfo = [NSMutableString stringWithString:@"\n\n-------App & Device info--------\n"];
    [deviceInfo appendFormat:@"- system: %@, %@\n", [device systemName], [device systemVersion]];
    [deviceInfo appendFormat:@"- app: %@, %@\n", [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    [deviceInfo appendString:@"-------End-------"];
    return deviceInfo;
}
@end