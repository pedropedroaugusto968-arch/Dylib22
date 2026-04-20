#import <UIKit/UIKit.h>

// --- INTERFACE DO GOMES ---
@interface SucSoftMenu : UIView
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIView *mainPanel;
@end

@implementation SucSoftMenu

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Botão Flutuante (Abre o Menu)
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(100, 100, 50, 50);
        self.menuButton.backgroundColor = [UIColor purpleColor];
        self.menuButton.layer.cornerRadius = 25;
        [self.menuButton setTitle:@"S" forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];

        // Painel Principal (Inicia Escondido)
        self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 250, 300)];
        self.mainPanel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.mainPanel.layer.borderColor = [UIColor purpleColor].CGColor;
        self.mainPanel.layer.borderWidth = 2;
        self.mainPanel.hidden = YES;
        [self addSubview:self.mainPanel];
    }
    return self;
}

- (void)toggleMenu {
    self.mainPanel.hidden = !self.mainPanel.hidden;
}

@end

// Chama o menu assim que o jogo abrir
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SucSoftMenu *menu = [[SucSoftMenu alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:menu];
    });
}
