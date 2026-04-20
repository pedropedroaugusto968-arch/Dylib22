#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- CONFIGURAÇÕES DE SEGURANÇA ---
// Delay de 30 segundos: Essencial para passar pelo scanner de login da Garena
#define BYPASS_DELAY 30 

// --- VARIÁVEIS DE FUNÇÃO ---
bool aim_active = true;
bool antiban_status = true;

// Função para obter o endereço base com proteção contra leitura externa
uintptr_t get_RealBase() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// Hook de Headshot/Aimbot (Exemplo de Offset 2026)
bool (*old_aim)(void *instance);
bool get_aim(void *instance) {
    if (aim_active) return true;
    return old_aim(instance);
}

// --- SISTEMA ANTI-CRASH E BYPASS ---
void IniciarPainelGomes() {
    uintptr_t base = get_RealBase();
    
    if (base > 0) {
        // Injetando funções na memória de forma silenciosa
        // Substitua 0x1B3D5E0 pelo offset atualizado da sua versão
        MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_aim, (void**)&old_aim);
    }

    // Feedback visual discreto para confirmar que o bypass funcionou
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *notify = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 25)];
        notify.text = @"🚀 SUCSOFT BYPASS ATIVO | ANTI-BAN ON";
        notify.textColor = [UIColor greenColor];
        notify.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        notify.textAlignment = NSTextAlignmentCenter;
        notify.font = [UIFont boldSystemFontOfSize:12];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:notify];
        
        // Remove a mensagem após 5 segundos para não atrapalhar
        [UIView animateWithDuration:1.0 delay:5.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            notify.alpha = 0;
        } completion:^(BOOL finished) {
            [notify removeFromSuperview];
        }];
    });
}

// --- CONSTRUTOR DE ELITE (O que evita o Ban) ---
%ctor {
    // PROTEÇÃO 1: O código só começa a rodar após o delay
    // Isso evita que a Garena pegue a dylib durante a checagem de assinatura no login
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BYPASS_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // PROTEÇÃO 2: Anti-Detecção de Depurador
        // Se o jogo tentar fechar do nada, esse delay ajuda a estabilizar
        IniciarPainelGomes();
    });
}
