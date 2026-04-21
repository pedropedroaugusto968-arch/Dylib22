#import <UIKit/UIKit.h>
#import <substrate.h>

static bool legitActive = false;
static bool neckActive = false;

@interface SpaceXitMini : UIView
@property (nonatomic, strong) UIView *panel;
+ (instancetype)shared;
- (void)toggle;
@end

@implementation SpaceXitMini
+ (instancetype)shared {
    static SpaceXitMini *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitMini alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return inst;
}

- (void)setup {
    if (self.panel) return;
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(30, 60, 150, 120)];
    self.panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    self.panel.layer.cornerRadius = 10;
    [self addSubview:self.panel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 40, 130, 30);
    [btn setTitle:@"LEGIT CAPA" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toggleLegit) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:btn];
}

- (void)toggleLegit { legitActive = !legitActive; }
- (void)toggle { [self setup]; self.hidden = !self.hidden; }
@end

%ctor {
    // Delay de 15s para evitar crash no login
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMini shared] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 2;
        tap.numberOfTapsRequired = 2;
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        if (win) {
            [win addSubview:[SpaceXitMini shared]];
            [win addGestureRecognizer:tap];
        }
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
