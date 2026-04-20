#import <UIKit/UIKit.h>
#import <substrate.h>

@interface SpaceXitMenuV4 : UIWindow
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *contentArea;
@property (nonatomic, strong) UILabel *sliderValueLabel;
+ (instancetype)sharedInstance;
- (void)toggle;
@end

@implementation SpaceXitMenuV4

+ (instancetype)sharedInstance {
    static SpaceXitMenuV4 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpaceXitMenuV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 280)];
    self.mainPanel.center = self.center;
    self.mainPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    self.mainPanel.layer.cornerRadius = 15;
    self.mainPanel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.mainPanel.layer.borderWidth = 2;
    [self addSubview:self.mainPanel];

    NSArray *tabs = @[@"COMBATE", @"ESP", @"CONFIG"];
    for (int i = 0; i < tabs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10 + (i * 125), 35, 120, 35);
        [btn setTitle:tabs[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        btn.layer.cornerRadius = 5;
        btn.tag = i;
        [btn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainPanel addSubview:btn];
    }
    self.contentArea = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 380, 185)];
    [self.mainPanel addSubview:self.contentArea];
    [self showCombate];
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in self.contentArea.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self showCombate];
    else if (s.tag == 1) [self showESP];
    else if (s.tag == 2) [self showConfig];
}

- (void)showCombate {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    l.text = @"AIMBOT V4"; l.textColor = [UIColor cyanColor];
    [self.contentArea addSubview:l];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(310, 5, 0, 0)];
    [self.contentArea addSubview:sw];

    self.sliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 300, 20)];
    self.sliderValueLabel.text = @"FOV DISTÂNCIA: 250";
    self.sliderValueLabel.textColor = [UIColor whiteColor];
    [self.contentArea addSubview:self.sliderValueLabel];

    UISlider *sd = [[UISlider alloc] initWithFrame:CGRectMake(15, 85, 350, 30)];
    sd.minimumValue = 0; sd.maximumValue = 500; sd.value = 250;
    [sd addTarget:self action:@selector(sdChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentArea addSubview:sd];
}

- (void)showESP {
    NSArray *items = @[@"LINHA V4", @"BOX V4", @"DISTÂNCIA"];
    for (int i = 0; i < items.count; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (i*45), 200, 30)];
        l.text = items[i]; l.textColor = [UIColor whiteColor];
        [self.contentArea addSubview:l];
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(310, 10 + (i*45), 0, 0)];
        [self.contentArea addSubview:sw];
    }
}

- (void)showConfig {
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 370, 170)];
    t.text = @"SPACE XIT V4 - SUPREME\n\nCONTATO: @eoo_gomes3\nVERSÃO JOGO: 1.123.1\n\n- 3 TOQUES COM 3 DEDOS PARA ABRIR.";
    t.textColor = [UIColor cyanColor]; t.backgroundColor = [UIColor clearColor]; t.editable = NO;
    [self.contentArea addSubview:t];
}

- (void)sdChange:(UISlider *)s {
    self.sliderValueLabel.text = [NSString stringWithFormat:@"FOV DISTÂNCIA: %d", (int)s.value];
}

- (void)toggle { [self setupUI]; self.hidden = !self.hidden; if (!self.hidden) [self makeKeyAndVisible]; }
@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *n) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMenuV4 sharedInstance] action:@selector(toggle)];
            t.numberOfTouchesRequired = 3; t.numberOfTapsRequired = 3;
            [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t];
        });
    }];
}
