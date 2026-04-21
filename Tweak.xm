#import <UIKit/UIKit.h>
#import <substrate.h>

// --- ESTADOS DO INJECT ---
static bool legitActive = false;
static bool neckActive = false;
static bool chestActive = false;

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
        inst.userInteractionEnabled = YES;
    });
    return inst;
}

- (void)setupMenu {
    if (self.panel) return;

    // Mini Painel Lateral (Discreto)
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 160, 180)];
    self.panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.panel.layer.cornerRadius = 8;
    self.panel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.panel.layer.borderWidth = 1.5;
    [self addSubview:self.panel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 160, 20)];
    title.text = @"SPACE MINI V4";
    title.textColor = [UIColor cyanColor];
    title.font = [UIFont boldSystemFontOfSize:12];
    title.textAlignment = NSTextAlignmentCenter;
    [self.panel addSubview:title];

    // Botão Legit
    [self createBtn:@"LEGIT HS" y:35 tag:1];
    // Botão Pescoço
    [self createBtn:@"HS PESCOÇO" y:75 tag:2];
    // Botão Peito
    [self createBtn:@"HS PEITO" y:115 tag:3];
}

- (void)createBtn:(NSString *)title y:(int)y tag:(int)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, y, 140, 30);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.layer.cornerRadius = 5;
    btn.tag = tag;
    [btn addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:btn];
}

- (void)actionPressed:(UIButton *)sender {
    if (sender.tag == 1) { legitActive = !legitActive; sender.backgroundColor = legitActive ? [UIColor blueColor] : [UIColor darkGrayColor]; }
    if (sender.tag == 2) { neckActive = !neckActive; sender.backgroundColor = neckActive ? [UIColor blueColor] : [UIColor darkGrayColor]; }
    if (sender.tag == 3) { chestActive = !chestActive; sender.backgroundColor = chestActive ? [UIColor blueColor] : [UIColor darkGrayColor]; }
}

- (void)toggle {
    [self setupMenu];
    self.hidden = !self.hidden;
}
@end

// --- HOOKS DE AUXÍLIO (REFERÊNCIA) ---

float (*orig_aim)(void *instance);
float get_aim(void *instance) {
    if (legitActive) return 4.5f;   // Legit Suave
    if (neckActive) return 7.0f;    // Puxa Pescoço
    if (chestActive) return 2.5f;   // Trava Peito
    return %orig;
}

// --- INICIALIZAÇÃO SEGURA ---

%ctor {
    // Delay de 20s para o Login do Facebook/Google não crashar
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Ativa os Hooks
        // MSHookFunction(..., get_aim, ...);

        // Gesto para abrir a mini telinha (2 toques com 2 dedos)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMini shared] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 2;
        tap.numberOfTapsRequired = 2;

        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        if (!win) win = [UIApplication sharedApplication].windows.firstObject;
        
        [win addSubview:[SpaceXitMini shared]];
        [win addGestureRecognizer:tap];
        
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
