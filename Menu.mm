#import <UIKit/UIKit.h>

@interface SpaceXitMenu : UIWindow
@end

@implementation SpaceXitMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
        
        // Proteção contra gravação
        if ([self respondsToSelector:@selector(setScreenCanBeCaptured:)]) {
            [self setScreenCanBeCaptured:NO];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 50, 50);
        btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        btn.layer.cornerRadius = 25;
        [btn setTitle:@"Xit" forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    return self;
}
@end
