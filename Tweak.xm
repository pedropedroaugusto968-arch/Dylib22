#import <UIKit/UIKit.h>
#import <substrate.h>

@interface SpaceXitV4 : UIWindow
@property (nonatomic, strong) UIView *mainPanel;
+ (instancetype)sharedInstance;
- (void)toggle;
@end

@implementation SpaceXitV4

+ (instancetype)sharedInstance {
    static SpaceXitV4 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // O menu só ganha tamanho e memória aqui, quando for chamado
        instance = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.windowLevel = UIWindowLevelStatusBar + 100.0;
        instance.backgroundColor = [UIColor clearColor];
        instance.hidden = YES;
        
        // Anti-Rastreio: Esconde da gravação de tela
        if ([instance respondsToSelector:@selector(setScreenRecordingDetached:)]) {
            [instance setValue:@(YES) forKey:@"screenRecordingDetached"];
        }
    });
    return instance;
}

- (void)setupUI {
    if (self.mainPanel) return;
    
    // Criando o painel de forma otimizada
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 220)];
    self.mainPanel.center = self.center;
    self.mainPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    self.mainPanel.layer.cornerRadius = 15;
    self.mainPanel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.mainPanel.layer.borderWidth = 1.0;
    [self addSubview:self.mainPanel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 350, 30)];
    title.text = @"SPACE XIT V4 - LOBBY ACTIVE";
    title.textColor = [UIColor cyanColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:16];
    [self.mainPanel addSubview:title];
}

- (void)toggle {
    [self setupUI];
    self.hidden = !self.hidden;
    if (!self.hidden) [self makeKeyAndVisible];
}
@end

// --- LÓGICA DE INJEÇÃO SEM TRAVAMENTO ---

%ctor {
    // 1. O Tweak inicia "morto". Não faz nada por 80 segundos.
    // Isso evita o lag no carregamento da Garena e na tela de login.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(80 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 sharedInstance] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 3;
        tap.numberOfTapsRequired = 3;

        // 2. Procura a janela de forma segura apenas UMA VEZ
        UIWindow *targetWin = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    targetWin = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!targetWin) targetWin = [UIApplication sharedApplication].keyWindow;

        if (targetWin) {
            [targetWin addGestureRecognizer:tap];
            
            // Pequeno feedback visual discreto (opcional) para saber que o bypass ativou
            NSLog(@"[SpaceXit] Bypass Loaded Successfully");
        }
    });
}

// 3. Anti-Crash de Logs (Silencioso para não pesar a CPU)
%hook NSFileManager
- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr {
    if ([path containsString:@"GarenaLog"] || [path containsString:@"crash_report"]) return NO;
    return %orig;
}
%end
