#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- VARIÁVEIS DE ATIVAÇÃO (O QUE TEM NO WINDOWS) ---
bool aimbot_head = false;
bool aim_smooth = true;
bool esp_lines = false;
bool no_recoil = false;
bool speed_hack = false;
bool high_jump = false;
bool fast_reload = false;

// --- CORREÇÃO DE TIPO (ANTI-ERRO GITHUB) ---
uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// --- HOOKS DE COMBATE (🎯 COMBAT & 🔫 WEAPON) ---

// Headshot / Aim Head
bool (*old_Head)(void *instance);
bool get_Head(void *instance) {
    if (aimbot_head) return true;
    return old_Head(instance);
}

// No Recoil (Regedit)
float (*old_Recoil)(void *instance);
float get_Recoil(void *instance) {
    if (no_recoil) return 0.0f;
    return old_Recoil(instance);
}

// Fast Reload
float (*old_Reload)(void *instance);
float get_Reload(void *instance) {
    if (fast_reload) return 0.0f; // Tempo zero de recarga
    return old_Reload(instance);
}

// --- HOOKS DE JOGADOR (🚶 PLAYER) ---

// Speed Hack
float (*old_Speed)(void *instance);
float get_Speed(void *instance) {
    if (speed_hack) return 2.5f; // Aumenta a velocidade
    return old_Speed(instance);
}

// --- INTERFACE IN-GAME (ESTILO EXTERNAL) ---
@interface SucSoftMenu : UIView
@end

@implementation SucSoftMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85]; // Fundo Dark Glass
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.layer.cornerRadius = 10;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 250, 30)];
        title.text = @"SUC SOFTWARES PRO";
        title.textColor = [UIColor purpleColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:title];

        // BOTÕES DE ATIVAÇÃO
        [self addToggle:@"🎯 Headshot" y:50 action:@selector(toggleHead)];
        [self addToggle:@"🔫 No Recoil" y:90 action:@selector(toggleRecoil)];
        [self addToggle:@"🚶 Speed Hack" y:130 action:@selector(toggleSpeed)];
        [self addToggle:@"⚡ Fast Reload" y:170 action:@selector(toggleReload)];
    }
    return self;
}

- (void)addToggle:(NSString *)name y:(int)y action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, y, 210, 35);
    [btn setTitle:name forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

// Ações dos Botões
- (void)toggleHead { aimbot_head = !aimbot_head; }
- (void)toggleRecoil { no_recoil = !no_recoil; }
- (void)toggleSpeed { speed_hack = !speed_hack; }
- (void)toggleReload { fast_reload = !fast_reload; }
@end

// --- CONSTRUTOR DE INJEÇÃO ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        uintptr_t base = get_BaseAddress();

        if (base > 0) {
            // APLICANDO OS HOOKS NOS OFFSETS (SUBSTITUA PELOS REAIS)
            MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_Head, (void**)&old_Head);
            MSHookFunction((void*)(base + 0x2C4F6A1), (void*)get_Recoil, (void**)&old_Recoil);
            MSHookFunction((void*)(base + 0x3D5E7B2), (void*)get_Speed, (void**)&old_Speed);
            MSHookFunction((void*)(base + 0x4E6F8C3), (void*)get_Reload, (void**)&old_Reload);
        }

        // Criar e mostrar o Menu do Gomes
        SucSoftMenu *menu = [[SucSoftMenu alloc] initWithFrame:CGRectMake(50, 50, 250, 300)];
        [[UIApplication sharedApplication].keyWindow addSubview:menu];
    });
}
