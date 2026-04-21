#import <UIKit/UIKit.h>
#import <substrate.h>

static bool legit_on = false;

@interface SpaceXitV4 : UIView
@property (nonatomic, strong) UIView *bg;
+ (instancetype)shared;
- (void)show;
@end

@implementation SpaceXitV4
+ (instancetype)shared {
    static SpaceXitV4 *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return inst;
}

- (void)setup {
    if (self.bg) return;
    self.bg = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 140, 80)];
    self.bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.bg.layer.cornerRadius = 12;
    [self addSubview:self.bg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 25, 120, 30);
    [btn setTitle:@"LEGIT ON" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.bg addSubview:btn];
}

- (void)click { 
    legit_on = !legit_on; 
    [(UIButton *)[self.bg subviews][0] setTitleColor:(legit_on ? [UIColor redColor] : [UIColor greenColor]) forState:UIControlStateNormal];
}

- (void)show { [self setup]; self.hidden = !self.hidden; }
@end

%hook UIApplication
- (bool)canOpenURL:(NSURL *)url {
    if ([[url absoluteString] containsString:@"fb"] || [[url absoluteString] containsString:@"google"]) return true;
    return %orig;
}
%end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 shared] action:@selector(show)];
        tap.numberOfTouchesRequired = 2;
        tap.numberOfTapsRequired = 2;
        
        UIWindow *win = nil;
        // Método seguro para iOS 13 até iOS 18
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    win = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!win) win = [UIApplication sharedApplication].keyWindow;
        
        if (win) {
            [win addSubview:[SpaceXitV4 shared]];
            [win addGestureRecognizer:tap];
            [SpaceXitV4 shared].hidden = YES;
        }
        
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
