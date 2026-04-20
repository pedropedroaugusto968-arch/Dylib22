#import <UIKit/UIKit.h>
#import <substrate.h>

@interface SpaceXitMenu : UIWindow
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *contentArea;
@property (nonatomic, strong) UILabel *sliderValueLabel;
+ (instancetype)sharedInstance;
- (void)toggle;
@end

@implementation SpaceXitMenu

+ (instancetype)sharedInstance {
    static SpaceXitMenu *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpaceXitMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    self.mainPanel.layer.borderWidth = 2;
    self.mainPanel.layer.borderColor = [UIColor cyanColor].CGColor;
    [self addSubview:self.mainPanel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 400, 25)];
    title.text = @"SPACE XIT - SUPREME MENU";
    title.textColor = [UIColor cyanColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:16];
    [self.mainPanel addSubview:title];

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
    self.contentArea.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    self.contentArea.layer.cornerRadius = 8;
    [self.mainPanel addSubview:self.contentArea];
    [self showCombate];
}

- (void)switchTab:(UIButton *)sender {
    for (UIView *v in self.contentArea.subviews) [v removeFromSuperview];
    if (sender.tag == 0) [self showCombate];
    else if (sender.tag == 1) [self showESP];
    else if (sender.tag == 2) [self showConfig];
}

- (void)showCombate {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    l.text = @"ATIVAR AIMBOT"; l.textColor = [UIColor whiteColor];
    [self.contentArea addSubview:l];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(310, 5, 0, 0)];
    sw.onTintColor = [UIColor cyanColor];
    [self.contentArea addSubview:sw];

    self.sliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 300, 20)];
    self.sliderValueLabel.text = @"DISTÂNCIA AIMBOT: 250";
    self.sliderValueLabel.textColor = [UIColor whiteColor];
    [self.contentArea addSubview:self.sliderValueLabel];

    UISlider *sd = [[UISlider alloc] initWithFrame:CGRectMake(15, 85, 350, 30)];
    sd.minimumValue = 0; sd.maximumValue = 500; sd.value = 250;
    sd.minimumTrackTintColor = [UIColor cyanColor];
    [sd addTarget:self action:@selector(sdChange:) forControlEvents:UIControlEventValueChanged];
    [self.contentArea addSubview:sd];
}

- (void)showESP {
    NSArray *esps = @[@"ESP CAIXA", @"ESP ESQUELETO", @"ESP LINHA"];
    for (int i = 0; i < esps.count; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (i * 45), 200, 30)];
        l.text = esps[i]; l.textColor = [UIColor whiteColor];
        [self.contentArea addSubview:l];
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(310, 10 + (i * 45), 0, 0)];
        sw.onTintColor = [UIColor greenColor];
        [self.contentArea addSubview:sw];
    }
}

- (void)showConfig {
    UITextView *txt = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 360, 150)];
    txt.text = @"SPACE XIT - OFICIAL\nCONTATO: @eoo_gomes3\n\n1. Ative as funções no lobby.\n2. Slider configura o FOV do Aimbot.\n3. Modo Streamer Ativo (Oculto em vídeos).";
    txt.textColor = [UIColor cyanColor];
    txt.backgroundColor = [UIColor clearColor];
    txt.editable = NO;
    [self.contentArea addSubview:txt];
}

- (void)sdChange:(UISlider *)s {
    self.sliderValueLabel.text = [NSString stringWithFormat:@"DISTÂNCIA AIMBOT: %d", (int)s.value];
}

- (void)toggle {
    [self setupUI];
    self.hidden = !self.hidden;
    if (!self.hidden) [self makeKeyAndVisible];
}
@end

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMenu sharedInstance] action:@selector(toggle)];
            tap.numberOfTouchesRequired = 3; tap.numberOfTapsRequired = 3;
            [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
        });
    }];
}
