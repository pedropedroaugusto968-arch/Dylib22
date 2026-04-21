#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

@interface SpaceXitV4 : UIWindow
@property (nonatomic, strong) UIView *menuBg;
+ (instancetype)sharedInstance;
- (void)abrirFechar;
@end

@implementation SpaceXitV4
+ (instancetype)sharedInstance {
    static SpaceXitV4 *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        inst.windowLevel = UIWindowLevelStatusBar + 1.0;
        inst.backgroundColor = [UIColor clearColor];
        inst.hidden = YES;
    });
    return inst;
}

- (void)abrirFechar {
    self.hidden = !self.hidden;
    if (!self.hidden) [self makeKeyAndVisible];
}
@end

// --- BYPASS ANTI-BAN E ANTI-BLACKLIST ---

// 1. Ocultação de ID do Aparelho (Anti-Blacklist)
%hook UIDevice
- (NSString *)identifierForVendor {
    return @"B4C3D2A1-F6E5-4D3C-B2A1-0987654321AB"; // ID Falso para evitar ban de hardware
}
%end

// 2. Bloqueio de Rastreio de Depuração (Anti-Ban)
%hookf(int, ptrace, int request, pid_t pid, caddr_t addr, int data) {
    if (request == 31) return 0; // PT_DENY_ATTACH: Engana o sistema de detecção da Garena
    return %orig;
}

// 3. Limpeza Automática de Logs (Anti-Report)
%hook NSFileManager
- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr {
    if ([path containsString:@"GarenaLog"] || [path containsString:@"crash_report"] || [path containsString:@"tdf"]) {
        return NO; // Impede o jogo de salvar provas do uso de script
    }
    return %orig;
}
%end

// --- INJEÇÃO MODERNA (CORRIGE ERRO DO GITHUB) ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(80 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 sharedInstance] action:@selector(abrirFechar)];
        tap.numberOfTouchesRequired = 3;
        tap.numberOfTapsRequired = 3;

        UIWindow *activeWindow = nil;
        // Lógica moderna para evitar o erro 'keyWindow is deprecated'
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) {
                            activeWindow = window;
                            break;
                        }
                    }
                }
            }
        }
        
        if (!activeWindow) activeWindow = [UIApplication sharedApplication].windows.firstObject;

        if (activeWindow) {
            [activeWindow addGestureRecognizer:tap];
            // Remove vestígios da injeção da memória
            unsetenv("DYLD_INSERT_LIBRARIES");
        }
    });
}
