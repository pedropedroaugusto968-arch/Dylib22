#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- VARIÁVEIS DO GOMES ---
bool h_active = true;

// AQUI ESTÁ A CORREÇÃO DO ERRO DA FOTO (Adicionei o cast (uintptr_t))
uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// Hook de Headshot
bool (*old_H)(void *instance);
bool get_H(void *instance) {
    if (h_active) return true;
    return old_H(instance);
}

%ctor {
    // 25 segundos para logar sem o método de 2 Free Fires
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        uintptr_t base = get_BaseAddress();
        if (base > 0) {
            // Aplica o Hook no Offset (Exemplo)
            MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_H, (void**)&old_H);
        }

        // Aviso visual discreto
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 20)];
        label.text = @"SUCSOFT ATIVO";
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        [[UIApplication sharedApplication].keyWindow addSubview:label];
    });
}
