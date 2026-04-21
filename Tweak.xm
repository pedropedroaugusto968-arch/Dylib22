#import <UIKit/UIKit.h>
#import <substrate.h>

static bool legit_active = false;

@interface SpaceXitV4 : UIView
@property (nonatomic, strong) UIView *p;
+ (instancetype)s;
- (void)t;
@end

@implementation SpaceXitV4
+ (instancetype)s {
    static SpaceXitV4 *i = nil;
    static dispatch_once_t o;
    dispatch_once(&o, ^{
        i = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return i;
}
- (void)setup {
    if (self.p) return;
    self.p = [[UIView alloc] initWithFrame:CGRectMake(40, 80, 150, 100)];
    self.p.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.p.layer.cornerRadius = 10;
    [self addSubview:self.p];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(10, 35, 130, 30);
    [b setTitle:@"LEGIT ON/OFF" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.p addSubview:b];
}
- (void)toggle { legit_active = !legit_active; }
- (void)t { [self setup]; self.hidden = !self.hidden; }
@end

%hook UIApplication
- (bool)canOpenURL:(NSURL *)u {
    if ([[u absoluteString] containsString:@"fb"] || [[u absoluteString] containsString:@"google"]) return true;
    return %orig;
}
%end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 s] action:@selector(t)];
        g.numberOfTouchesRequired = 2;
        g.numberOfTapsRequired = 2;
        
        UIWindow *w = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    w = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!w) w = [UIApplication sharedApplication].windows.firstObject;
        
        if (w) {
            [w addSubview:[SpaceXitV4 s]];
            [w addGestureRecognizer:g];
        }
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
