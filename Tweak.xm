#import <UIKit/UIKit.h>
#import <substrate.h>

// --- BYPASS DE LOGIN ---
// Permite que o jogo abra janelas de autenticação sem crashar
%hook UIApplication
- (bool)canOpenURL:(NSURL *)url {
    NSString *u = [url absoluteString];
    if ([u containsString:@"fb"] || [u containsString:@"google"] || [u containsString:@"garena"]) {
        return true; 
    }
    return %orig;
}
%end

// --- INICIALIZAÇÃO SILENCIOSA ---
%ctor {
    // Delay de 15 segundos para o Anti-Cheat não detectar nada no boot
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Remove rastros de injeção da memória
        unsetenv("DYLD_INSERT_LIBRARIES");
        unsetenv("_DYLD_INSERT_LIBRARIES");
        
        NSLog(@"[Anti-Crash] Proteção ativada com sucesso.");
    });
}
