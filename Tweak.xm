#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// Delay de 30s para o Bypass total no login
#define BYPASS_DELAY 30 

uintptr_t get_RealBase() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// Hook de Headshot (Ajuste o Offset se necessário)
bool (*old_aim)(void *instance);
bool get_aim(void *instance) {
    return true; 
}

void AtivarHackGomes() {
    uintptr_t base = get_RealBase();
    if (base > 0) {
        // Offset de exemplo - Protegido por Memory Stealth
        MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_aim, (void**)&old_aim);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *notify = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30)];
        notify.text = @"🚀 SUCSOFT: BYPASS & ANTI-DETECÇÃO ON";
        notify.textColor = [UIColor whiteColor];
        notify.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.7];
        notify.textAlignment = NSTextAlignmentCenter;
        notify.font = [UIFont boldSystemFontOfSize:12];
        [[UIApplication sharedApplication].keyWindow addSubview:notify];
        
        [UIView animateWithDuration:1.0 delay:5.0 options:0 animations:^{ notify.alpha = 0; } completion:^(BOOL f){ [notify removeFromSuperview]; }];
    });
}

%ctor {
    // Só ativa após 30 segundos para a Garena não detectar a dylib no login
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BYPASS_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AtivarHackGomes();
    });
}
