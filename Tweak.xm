#import <UIKit/UIKit.h>
#import <substrate.h>

@interface SpaceXitV4 : UIWindow
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *contentArea;
@property (nonatomic, strong) UILabel *sliderLabel;
+ (instancetype)sharedInstance;
- (void)toggle;
@end

@implementation SpaceXitV4

+ (instancetype)sharedInstance {
    static SpaceXitV4 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.windowLevel = UIWindowLevelStatusBar + 100.0;
        instance.backgroundColor = [UIColor clearColor];
        instance.hidden = YES;
        if ([instance respondsToSelector:@selector(setScreenRecordingDetached:)]) {
            [instance setValue:@(YES) forKey:@"screenRecordingDetached"];
        }
    });
    return instance;
}

- (void)setupUI {
    if (self.mainPanel) return;
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 260)];
    self.mainPanel.center = self.center;
    self.mainPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    self.mainPanel.layer.cornerRadius = 12;
    self.mainPanel.layer.borderWidth = 1.5;
    self.mainPanel.layer.borderColor = [UIColor cyanColor].CGColor;
    [self addSubview:self.mainPanel];

    NSArray *tabs = @[@"COMBATE", @"ESP", @"INFO"];
    for (int i = 0; i < tabs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10 + (i * 120), 35, 115, 30);
        [btn setTitle:tabs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        btn.layer.cornerRadius = 4;
        btn.tag = i;
        [btn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainPanel addSubview:btn];
    }
    self.contentArea = [[UIView alloc] initWithFrame:CGRectMake(10, 70, 360, 175)];
    [self.mainPanel addSubview:self.contentArea];
    [self showCombate];
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in self.contentArea.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self showCombate];
    else if (s.tag == 1) [self showESP];
    else if (s.tag == 2) [self showInfo];
}

- (void)showCombate {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
    l.text = @"AIMBOT V4"; l.textColor = [UIColor whiteColor];
    [self.contentArea addSubview:l];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(300, 5, 0, 0)];
    [self.contentArea addSubview:sw];
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20)];
    self.sliderLabel.text = @"FOV: 250"; self.sliderLabel.textColor = [UIColor cyanColor];
    [self.contentArea addSubview:self.sliderLabel];
    UISlider *sd = [[UISlider alloc] initWithFrame:CGRectMake(10, 75, 340, 30)];
    sd.minimumValue = 0; sd.maximumValue = 500; sd.value = 250;
    [sd addTarget:self action:@selector(sdChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentArea addSubview:sd];
}

- (void)showESP {
    NSArray *ops = @[@"LINHA V4", @"BOX V4", @"NOME"];
    for (int i = 0; i < ops.count; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + (i * 45), 200, 25)];
        l.text = ops[i]; l.textColor = [UIColor whiteColor];
        [self.contentArea addSubview:l];
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(300, 10 + (i * 45), 0, 0)];
        [self.contentArea addSubview:sw];
    }
}

- (void)showInfo {
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 350, 160)];
    tv.text = @"SPACE XIT V4\nDev: @eoo_gomes3\n\n- Anti-Crash Login 2.0\n- 3 Dedos / 3 Toques";
    tv.textColor = [UIColor cyanColor]; tv.backgroundColor = [UIColor clearColor]; tv.editable = NO;
    [self.contentArea addSubview:tv];
}

- (void)sdChange:(UISlider *)s {
    self.sliderLabel.text = [NSString stringWithFormat:@"FOV: %d", (int)s.value];
}

- (void)toggle { 
    [self setupUI]; 
    self.hidden = !self.hidden; 
    if (!self.hidden) [self makeKeyAndVisible]; 
}
@end

// Hook de segurança para evitar crash no carregamento
%hook UnityAppController
- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Espera 60 segundos após o app ficar ativo para carregar o gesto
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 sharedInstance] action:@selector(toggle)];
            tap.numberOfTouchesRequired = 3;
            tap.numberOfTapsRequired = 3;
            
            UIWindow *win = nil;
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive) {
                        win = scene.windows.firstObject;
                        break;
                    }
                }
            }
            if (!win) win = [UIApplication sharedApplication].keyWindow;
            [win addGestureRecognizer:tap];
        });
    });
}
%end
