#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// Variáveis de ativação
bool aimbot_head = true;
bool regedit_full = true;

// Correção para o erro de compilação do GitHub
uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// --- FUNÇÕES DE COMBATE ---
bool (*old_Head)(void *instance);
bool get_Head(void *instance) {
    if (aimbot_head) return true;
    return old_Head(instance);
}

float (*old_Recoil)(void *instance);
float get_Recoil(void *instance) {
    if (regedit_full) return 0.0f;
    return old_Recoil(instance);
}

// --- INICIALIZAÇÃO SEGURA (SINGLE APP) ---
void aplicar_hooks() {
    uintptr_t base = get_BaseAddress();
    if (base > 0) {
        // Substitua os Offsets pelos atuais do dump do Free Fire
        MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_Head, (void**)&old_Head);
        MSHookFunction((void*)(base + 0x2C4F6A1), (void*)get_Recoil, (void**)&old_Recoil);
        NSLog(@"[SucSoft] Sistema Ativo com Sucesso!");
    }
}

%ctor {
    // DELAY DE 25 SEGUNDOS: 
    // Essencial para passar pela checagem de login da Garena sem crashar.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Criar Menu Simples do Gomes
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 180, 100)];
        bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        bg.layer.borderColor = [UIColor purpleColor].CGColor;
        bg.layer.borderWidth = 2;
        [[UIApplication sharedApplication].keyWindow addSubview:bg];

        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 180, 20)];
        txt.text = @"SUCSOFT PRO - ON";
        txt.textColor = [UIColor whiteColor];
        txt.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:txt];

        aplicar_hooks();
    });
}
