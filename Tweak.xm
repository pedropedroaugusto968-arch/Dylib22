#import <UIKit/UIKit.h>
#import <substrate.h>

@interface SpaceXitV4 : UIWindow
@property (nonatomic, strong) UIView *container;
+ (instancetype)sharedInstance;
- (void)toggleMenu;
@end

@implementation SpaceXitV4
+ (instancetype)sharedInstance {
    static SpaceXitV4 *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        inst.windowLevel = UIWindowLevelStatusBar + 100.0;
        inst.backgroundColor = [UIColor clearColor];
        inst.hidden = YES;
    });
    return inst;
}

- (void)toggleMenu {
    self.hidden = !self.hidden;
    if (!self.hidden) [self makeKeyAndVisible];
}
@end

// --- BYPASS ANTI-BAN & BLACKLIST V4 ---

%hook UIDevice
- (NSString *)identifierForVendor {
    // HWID Bypass para evitar Blacklist no aparelho
    return @"D6E5F4A3-B2C1-4D0E-A9F8-1234567890AB";
}
%end

%hook NSFileManager
- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr {
    // Bloqueia logs da Garena de forma silenciosa
    if ([path containsString:@"GarenaLog"] || [path containsString:@"crash_report"]) {
        return NO;
    }
    return %orig;
}
%end

// --- INICIALIZAÇÃO SEGURA (FIX COMPILADOR GITHUB) ---

%ctor {
    // Delay de 85 segundos para total segurança no Login
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(85 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 sharedInstance] action:@selector(toggleMenu)];
        tap.numberOfTouchesRequired = 3;
        tap.numberOfTapsRequired = 3;

        UIWindow *activeWin = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    activeWin = scene.windows.firstObject;
                    break;
                }
            }
        }
        
        if (!activeWin) activeWin = [UIApplication sharedApplication].windows.firstObject;

        if (activeWin) {
            [activeWin addGestureRecognizer:tap];
            // Remove vestígios da dylib da memória após carregar
            unsetenv("DYLD_INSERT_LIBRARIES");
        }
    });
}
