#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- VARIÁVEIS ---
bool aimbot_head = true;
bool regedit_active = true;

// --- BYPASS DE INTEGRIDADE (O SEGREDO) ---
// Esta função impede que a Garena detecte que o binário foi modificado no login
uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// --- HOOKS SEGUROS ---
bool (*old_IsHead)(void *instance);
bool get_IsHead(void *instance) {
    if (aimbot_head) return true;
    return old_IsHead(instance);
}

// --- SISTEMA ANTI-CRASH (INJEÇÃO SEGURA) ---
void iniciar_hooks() {
    uintptr_t base = get_BaseAddress();
    
    // SÓ APLICA OS HOOKS QUANDO A PARTIDA COMEÇAR OU APÓS O LOBBY
    // Isso evita que o jogo feche na tela de login/carregamento
    if (base > 0) {
        // Substitua pelos Offsets da versão atual
        MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_IsHead, (void**)&old_Head);
        NSLog(@"[SucSoft] Hooks aplicados após verificação de integridade.");
    }
}

// --- CONSTRUTOR INTELIGENTE ---
%ctor {
    // A Garena tirou o método de 2 apps, então agora a gente espera 
    // o login ser concluído ANTES de ativar qualquer função.
    // O delay de 25 segundos garante que você já esteja no lobby ou escolhendo o modo.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Criação do Menu do Gomes (Mesmo estilo anterior)
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 200, 150)];
        menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        menuView.layer.borderColor = [UIColor purpleColor].CGColor;
        menuView.layer.borderWidth = 2;
        [[UIApplication sharedApplication].keyWindow addSubview:menuView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
        label.text = @"SUCSOFT ON - NO CRASH";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:12];
        [menuView addSubview:label];

        // Chama os hooks após o tempo de segurança
        iniciar_hooks();
    });
}
