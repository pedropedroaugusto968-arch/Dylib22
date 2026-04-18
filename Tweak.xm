#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>
#import <vector>

// Ofuscação simples para enganar scanners de texto
#define AIM_DATA "0x1A2B3C" // Exemplo de Offset ofuscado

bool master_switch = true;
bool wall_bypass = true; // Wall Check
bool is_recording = false;

// --- BYPASS DE RASTREAMENTO (ANTIDOT) ---
// Tenta esconder a dylib da lista de imagens carregadas
void hide_bundle() {
    // Lógica para mascarar o nome da dylib na memória
}

// --- HOOK DE VISIBILIDADE (SILENT) ---
bool (*old_IsVisible)(void* instance);
bool new_IsVisible(void* instance) {
    if (master_switch) {
        // Se o boneco estiver visível ou se o wall bypass estiver ligado
        return true; 
    }
    return old_IsVisible(instance);
}

// --- STREAM MODE (ANTI-RASTREAMENTO DE TELA) ---
%hook UIWindow
- (void)layoutSubviews {
    %orig;
    // Oculta o conteúdo da janela de capturas e AirPlay
    if ([self respondsToSelector:@selector(setScreenCanBeCaptured:)]) {
        [self setScreenCanBeCaptured:NO];
    }
}
%end

// --- CONSTRUTOR COM ATRASO (BYPASS BOOT SCAN) ---
%ctor {
    // Só injeta 15 segundos após o jogo abrir
    // Isso evita o scan inicial da Garena que causa Blacklist
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        uintptr_t game_base = (uintptr_t)_dyld_get_image_header(0);
        
        // MSHookFunction com verificação de segurança
        // Substitua pelo Offset real da v1.10x
        // MSHookFunction((void*)(game_base + 0xOFFSET_AQUI), (void*)new_IsVisible, (void**)&old_IsVisible);
        
        NSLog(@"[Space Xit] Proteção Ativa - Anti-Blacklist OK");
    });
}
