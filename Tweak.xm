#import <UIKit/UIKit.h>
#import <substrate.h>

// Variáveis de controle
static bool is_logged_in = false;

@interface SpaceXitV4 : UIView
@property (nonatomic, strong) UIView *panel;
+ (instancetype)shared;
@end

@implementation SpaceXitV4
+ (instancetype)shared {
    static SpaceXitV4 *inst = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        inst = [[SpaceXitV4 alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return inst;
}
// (O restante do código do seu mini painel entra aqui)
@end

// --- SISTEMA ANTI-TRAVAMENTO ---

%hook UIApplication
// 1. Evita que o jogo trave ao abrir janelas externas de login (Google/FB)
- (bool)canOpenURL:(NSURL *)url {
    NSString *u = [url absoluteString];
    if ([u containsString:@"fb"] || [u containsString:@"google"] || [u containsString:@"garena"]) {
        return true; 
    }
    return %orig;
}

// 2. Garante que o processo de login receba prioridade total da CPU
- (void)openURL:(NSURL*)url options:(NSDictionary<NSString *,id> *)options completionHandler:(void (^)(BOOL success))completion {
    %orig(url, options, completion);
}
%end

// --- INJETOR INTELIGENTE ---

void InjetarScripts() {
    if (is_logged_in) return;
    
    // Aqui você coloca seus MSHookFunction
    // MSHookFunction((void *)0xOFFSET, ...);
    
    is_logged_in = true;
    NSLog(@"[SpaceXit] Scripts injetados com sucesso após login.");
}

%ctor {
    // O segredo do Anti-Crash:
    // Aguarda o jogo carregar completamente a interface (25 segundos)
    // Isso dá tempo de você digitar sua senha e entrar sem lag.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Limpa rastro de injeção para o Anti-Cheat não travar o login
        unsetenv("DYLD_INSERT_LIBRARIES");

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window && @available(iOS 13.0, *)) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }

        if (window) {
            [window addSubview:[SpaceXitV4 shared]];
            InjetarScripts();
        }
    });
}
