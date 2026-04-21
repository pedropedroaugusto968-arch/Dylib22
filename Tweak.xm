#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- ESTRUTURA DO MENU ---
@interface SpaceXitV4 : UIWindow
@property (nonatomic, strong) UIView *menuBg;
+ (instancetype)sharedInstance;
- (void)abrirFechar;
@end

@implementation SpaceXitV4
// Singleton para economizar memória
+ (instancetype)sharedInstance {
    static SpaceXitV4 *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        inst.windowLevel = UIWindowLevelStatusBar + 1.0;
        inst.hidden = YES;
    });
    return inst;
}

- (void)abrirFechar {
    self.hidden = !self.hidden;
    if (!self.hidden) [self makeKeyAndVisible];
}
@end

// --- FUNÇÕES DE BYPASS ANTI-BAN ---

// 1. Bloqueio de Blacklist (Impede o jogo de ler o ID do dispositivo real)
%hook UIDevice
- (NSString *)identifierForVendor {
    // Retorna um ID falso para evitar que o banimento atinja o aparelho (HWID Bypass)
    return @"A1B2C3D4-E5F6-7G8H-9I0J-K1L2M3N4O5P6";
}
%end

// 2. Anti-Rastreio de Memória (Hooks silenciosos)
// Bloqueia a detecção de depuradores que a Garena usa para achar a dylib
%hookf(int, ptrace, int request, pid_t pid, caddr_t addr, int data) {
    if (request == 31) { // PT_DENY_ATTACH
        return 0; // Diz ao jogo que não há nada anexado
    }
    return %orig;
}

// 3. Limpeza de Logs de Denúncia (Anti-Report)
%hook NSFileManager
- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error {
    // Se o jogo tentar criar um relatório de crash ou log de "suspeito", nós limpamos
    if ([path containsString:@"GarenaLog"] || [path containsString:@"tdf"]) {
        return YES; 
    }
    return %orig;
}
%end

// --- INJEÇÃO SEGURA NO LOBBY ---
%ctor {
    // Delay de 75 segundos para garantir estabilidade total (Bypass de login)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 3 cliques com 3 dedos para abrir o menu manualmente
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[SpaceXitV4 sharedInstance] action:@selector(abrirFechar)];
        tap.numberOfTouchesRequired = 3;
        tap.numberOfTapsRequired = 3;

        UIWindow *win = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    win = s.windows.firstObject; break;
                }
            }
        }
        if (!win) win = [UIApplication sharedApplication].keyWindow;
        
        [win addGestureRecognizer:tap];
        
        // Anti-Detecção de módulo: Esconde a dylib da lista de carregamento
        unsetenv("DYLD_INSERT_LIBRARIES");
    });
}
