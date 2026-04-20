#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- VARIAVEIS GLOBAIS ---
bool aimbot_head = true;
bool regedit_full = true;
bool bypass_active = true;

// --- BUSCA DO ENDEREÇO BASE (ANTI-ASLR) ---
uintptr_t get_BaseAddress() {
    return _dyld_get_image_header(0);
}

// --- HOOKS: REGEDIT & FFH4X ---

// Função de Headshot (Grudar na cabeça)
bool (*old_IsHeadShot)(void *instance);
bool get_IsHeadShot(void *instance) {
    if (aimbot_head) return true; 
    return old_IsHeadShot(instance);
}

// Função de No Recoil (Mira não sobe)
float (*old_RecoilValue)(void *instance);
float get_RecoilValue(void *instance) {
    if (regedit_full) return 0.0f;
    return old_RecoilValue(instance);
}

// --- CONSTRUTOR (BYPASS) ---
%ctor {
    // Delay de 5 segundos para o Anti-Cheat carregar e nós "passarmos por cima"
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        uintptr_t base = get_BaseAddress();

        // Aplicando os Hooks nos endereços (Exemplos de Offsets)
        // Você deve atualizar esses hexadecimais após dar o dump no binário
        MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_IsHeadShot, (void**)&old_IsHeadShot);
        MSHookFunction((void*)(base + 0x2C4F6A1), (void*)get_RecoilValue, (void**)&old_RecoilValue);

        NSLog(@"[SucSoft] Gomes, o Painel está ON e Blindado!");
    });
}
