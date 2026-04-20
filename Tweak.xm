#import <UIKit/UIKit.h>
#import <substrate.h>

// --- CONFIGURAÇÃO SPACE XIT ---
#define BYPASS_DELAY 25

@interface SpaceXitOverlay : UIWindow
+ (instancetype)sharedInstance;
- (void)toggleMenu;
@end

@implementation SpaceXitOverlay
static SpaceXitOverlay *instance = nil;

+ (instancetype)sharedInstance {
    if (!instance) {
        // Cria a janela no tamanho da tela
        instance = [[SpaceXitOverlay alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.windowLevel = UIWindowLevelStatusBar + 100.0;
        instance.backgroundColor = [UIColor clearColor];
        instance.hidden = YES; // Começa escondido
        
        // --- FUNÇÃO MOD STREAMER (OCULTAR DE GRAVAÇÃO) ---
        // Isso impede que o painel apareça em prints e vídeos
        if ([instance respondsToSelector:@selector(setScreenRecordingDetached:)]) {
            [instance setValue:@(YES) forKey:@"screenRecordingDetached"];
        }
    }
    return instance;
}

- (void)toggleMenu {
    self.hidden = !self.hidden;
    if (!self.hidden) {
        [self makeKeyAndVisible];
        [self setupUI];
    }
}

- (void)setupUI {
    // Remove o que já existia para não dar lag
    for (UIView *view in self.subviews) [view removeFromSuperview];

    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 180)];
    panel.center = self.center;
    panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    panel.layer.cornerRadius = 15;
    panel.layer.borderWidth = 2;
    panel.layer.borderColor = [UIColor cyanColor].CGColor;
    [self addSubview:panel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 280, 25)];
    title.text = @"SPACE XIT - STREAMER MODE";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:14];
    [panel addSubview:title];
    
    // Botão para fechar/ocultar via menu
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(240, 5, 30, 30);
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:closeBtn];
}
@end

// --- ATIVAÇÃO COM 3 CLIQUES E 3 DEDOS ---
void IniciarGesto() {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitOverlay sharedInstance] action:@selector(toggleMenu)];
    tap.numberOfTouchesRequired = 3; // 3 Dedos
    tap.numberOfTapsRequired = 3;    // 3 Cliques rápidos
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
}

%ctor {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        // Ativa após o delay de segurança para evitar detecção no login
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BYPASS_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            IniciarGesto();
            
            // Notificação discreta de que o Bypass carregou
            NSLog(@"[SpaceXit] Bypass Total Injetado");
        });
    }];
}
