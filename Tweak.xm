#import <UIKit/UIKit.h>
#import <substrate.h>

// --- SPACE XIT ELITE CONFIG ---
#define BYPASS_TIME 20

@interface SpaceXitMenu : UIWindow
+ (instancetype)sharedInstance;
- (void)toggle;
@end

@implementation SpaceXitMenu
static SpaceXitMenu *instance = nil;

+ (instancetype)sharedInstance {
    if (!instance) {
        instance = [[SpaceXitMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.windowLevel = UIWindowLevelStatusBar + 100.0;
        instance.backgroundColor = [UIColor clearColor];
        instance.hidden = YES;
        
        // MODO STREAMER (Não aparece em vídeos/prints)
        if ([instance respondsToSelector:@selector(setScreenRecordingDetached:)]) {
            [instance setValue:@(YES) forKey:@"screenRecordingDetached"];
        }
    }
    return instance;
}

- (void)toggle {
    self.hidden = !self.hidden;
    if (!self.hidden) {
        [self makeKeyAndVisible];
        [self drawUI];
    }
}

- (void)drawUI {
    for (UIView *v in self.subviews) [v removeFromSuperview];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    bg.center = self.center;
    bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    bg.layer.cornerRadius = 12;
    bg.layer.borderWidth = 1.5;
    bg.layer.borderColor = [UIColor greenColor].CGColor;
    [self addSubview:bg];

    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 20)];
    l.text = @"SPACE XIT - ANTI CRASH";
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont boldSystemFontOfSize:12];
    [bg addSubview:l];
}
@end

// --- ATIVAÇÃO 3 CLIQUES COM 3 DEDOS ---
void IniciarGesto() {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMenu sharedInstance] action:@selector(toggle)];
    tap.numberOfTouchesRequired = 3;
    tap.numberOfTapsRequired = 3;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
}

%ctor {
    // ESSENCIAL: Espera o jogo carregar totalmente para evitar crash no login
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BYPASS_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            IniciarGesto();
            NSLog(@"[SpaceXit] Bypass de Login Ativado");
        });
    }];
}
