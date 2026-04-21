#import <UIKit/UIKit.h>
#import <substrate.h>

// Variáveis para o Mini Menu
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
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 160, 150)];
    self.panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.panel.layer.cornerRadius = 10;
    [self addSubview:self.panel];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 40, 140, 30);
    [btn setTitle:@"LEGIT CAPA" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:btn];
}

- (void)action1 { legitActive = !legitActive; }
- (void)toggle { [self setupMenu]; self.hidden = !self.hidden; }
@end

// --- HOOKS (Onde o %orig faz sentido) ---

%hook UIApplication
- (bool)canOpenURL:(NSURL *)url {
    // Anti-Crash Login: Permite Google/FB
    if ([[url absoluteString] containsString:@"fb"] || [[url absoluteString] containsString:@"google"]) {
        return true;
    }
    return %orig; // AQUI o %orig funciona corretamente
}
%end

// --- AUXÍLIO DE MIRA INJECT ---

float (*orig_aim)(void *instance);
float get_aim(void *instance) {
    if (legitActive) return 4.5f;
    if (neckActive) return 7.0f;
    return 1.0f; // Retorno padrão caso nada esteja ativo
}

// --- CONSTRUTOR ---

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Ativa o gesto de 2 toques / 2 dedos para o mini menu
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitMini shared] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 2;
        tap.numberOfTapsRequired = 2;

        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        if (!win) win = [UIApplication sharedApplication].windows.firstObject;
        
        if (win) {
            [win addSubview:[SpaceXitMini shared]];
            [win addGestureRecognizer:tap];
        }
        
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
