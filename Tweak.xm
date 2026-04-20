#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

bool head_active = true;

uintptr_t get_BaseAddress() {
    return (uintptr_t)_dyld_get_image_header(0);
}

bool (*old_Head)(void *instance);
bool get_Head(void *instance) {
    if (head_active) return true;
    return old_Head(instance);
}

%ctor {
    // Delay para passar pelo login da Garena sem crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        uintptr_t base = get_BaseAddress();
        if (base > 0) {
            // Use os offsets atualizados aqui
            MSHookFunction((void*)(base + 0x1B3D5E0), (void*)get_Head, (void**)&old_Head);
        }
        
        // Pequeno aviso visual que o SucSoft carregou
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 200, 20)];
        msg.text = @"SUCSOFT ON";
        msg.textColor = [UIColor purpleColor];
        msg.textAlignment = NSTextAlignmentCenter;
        [[UIApplication sharedApplication].keyWindow addSubview:msg];
    });
}
