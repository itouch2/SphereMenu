//
//  SphereMenu.m
//  SphereMenu
//

#import "SphereMenu.h"

static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 150;
static const float kSphereDamping = 0.3;



@protocol SphereModelViewDelegate <NSObject>

@optional
- (void)modelMenuViewDidTouchEnd:(id)menuView;

@end


@interface SphereModelView : UIView

@property (nonatomic) id<SphereModelViewDelegate> delegate;

@end


@implementation SphereModelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(modelMenuViewDidTouchEnd:)]) {
        
        [self.delegate modelMenuViewDidTouchEnd:self];
    }
}

@end




@interface SphereMenu () <UICollisionBehaviorDelegate, SphereModelViewDelegate>


@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat sphereDamping;
@property (nonatomic, assign) CGFloat sphereLength;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *positions;

// animator and behaviors
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) NSMutableArray *snaps;

@property (nonatomic, strong) id<UIDynamicItem> bumper;
@property (nonatomic, assign) BOOL expanded;



// -- add by Olive

@property (nonatomic, strong) UIView *anchorView;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIButton *anchorBtn;

@property (nonatomic, strong) SphereModelView *modelView;

@property (nonatomic, strong) NSArray *menusViewArray;

@property (nonatomic, strong) SpherePickedMenu pickedCompletion;

// -- end by Olive

@end


@implementation SphereMenu


+ (instancetype)showSphereMenuWithAnchorView:(UIView *)anchorView
                                 anchorImage:(UIImage *)anchorImg
                                 sphereMenus:(NSArray *(^)())menus
                                  pickedMenu:(SpherePickedMenu)completion
{
    SphereMenu *menu = [[SphereMenu alloc] init];
    menu.menusViewArray = menus();
    menu.anchorView = anchorView;
    menu.pickedCompletion = completion;
    
    menu.normalImage = anchorImg;
    
    [menu show];
    
    
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _angle = kAngleOffset;
        _sphereLength = kSphereLength;
        _sphereDamping = kSphereDamping;
    }
    
    return self;
}

- (UIWindow *)window
{
    return [[UIApplication sharedApplication] keyWindow];
}

- (SphereModelView *)modelView
{
    if (!_modelView) {
        
        _modelView = [[SphereModelView alloc] initWithFrame:self.window.bounds];
        _modelView.delegate = self;
    }
    
    return _modelView;
}

- (void)show
{
    //self.anchorView.hidden = YES;
    
    _angle = M_PI / (self.menusViewArray.count+1);
    
    [self.window addSubview:self.modelView];
    
    self.modelView.frame = CGRectMake(0, self.modelView.bounds.size.height, self.modelView.bounds.size.width, 0);
    [UIView animateWithDuration:_sphereDamping
                     animations:^{
                         
                         self.modelView.frame = self.window.bounds;
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
    //NSLog(@"anchor ori frame = %@", NSStringFromCGRect(self.anchorView.frame));
    CGRect rect = [self.anchorView.superview convertRect:self.anchorView.frame toView:self.window];
    //NSLog(@"rect = %@", NSStringFromCGRect(rect));
    
    self.frame = rect;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    [btn setImage:self.normalImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(anchorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [self.window addSubview:self];
    
    
    [self commonSetup];
    
    [self expandSubmenu];
}

#pragma mark -Action
- (void)anchorBtnAction:(UIButton *)sender
{
    [self shrinkSubmenu:^{
        
    }];
}

- (void)menuItemPickedAction:(UIControl *)sender
{
    [self shrinkSubmenu:^{
        
        if (self.pickedCompletion) {
         
            NSInteger i = sender.tag;
            self.pickedCompletion(i, sender);
        }
    }];
}

#pragma mark -Private Methods
#define SPHERE_TITLE_LABEL_HEIGHT   30
- (void)commonSetup
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];

    CGRect rect = CGRectZero;
    
    NSInteger count = self.menusViewArray.count;
    // setup the items
    for (int i = 0; i < count; i++) {
        
        UIImage *img = self.menusViewArray[i][key_sphere_menu_image];
        NSString *title = self.menusViewArray[i][key_sphere_menu_title];
        
        rect.size.width = img.size.width;
        rect.size.height = img.size.height + SPHERE_TITLE_LABEL_HEIGHT;
        
        UIControl *view = [[UIControl alloc] initWithFrame:rect];
        view.tag = i;
        view.backgroundColor = [UIColor clearColor];
        [view addTarget:self action:@selector(menuItemPickedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [view addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, img.size.height, img.size.width, SPHERE_TITLE_LABEL_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
//        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];
        
        view.center = self.center;
        
        [self.superview addSubview:view];
        
        CGPoint position = [self centerForSphereAtIndex:i];
        view.center = self.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];

        // UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        // [view addGestureRecognizer:pan];
        
        [self.items addObject:view];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    for (int i = 0; i < count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = self.sphereDamping;
        [self.snaps addObject:snap];
    }
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)removeAllSubViews:(void (^)())completion
{
    [UIView animateWithDuration:_sphereDamping
                     animations:^{
                         
                         self.modelView.frame = CGRectMake(0, self.modelView.bounds.size.height, self.modelView.bounds.size.width, 0);
                     }
                     completion:^(BOOL finished) {
                         
                         [self.modelView removeFromSuperview];
                         
                         for (UIView *view in self.items) {
                             [view removeFromSuperview];
                         }
                         [self removeFromSuperview];
                         
                         completion();
                     }];
}

- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat cosAngle = 0;
    if (index*self.angle > M_PI_4)
        cosAngle = M_PI - (index+1)*self.angle;
    else
        cosAngle = M_PI_2 + (M_PI_2 - (index+1)*self.angle);
    
    CGFloat sinAngle = (index+1)*self.angle;
    
//    CGFloat firstAngle = M_PI + (M_PI_4 - self.angle) + index * self.angle;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(cosAngle) * self.sphereLength;
    //NSLog(@"start x = %f, index = %d, x = %f", startPoint.x, index, x);
    CGFloat y = startPoint.y - sin(sinAngle) * self.sphereLength;
    //NSLog(@"start y = %f, index = %d, y = %f", startPoint.y, index, y);
    CGPoint position = CGPointMake(x, y);
    return position;
}

// TODO: --展开menu
- (void)expandSubmenu
{
    for (int i = 0; i < self.items.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
    
    self.expanded = YES;
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

// TODO: --关闭menu
- (void)shrinkSubmenu:(void (^)())completion
{
    [self.animator removeBehavior:self.collision];
    
    for (int i = 0; i < self.items.count; i++) {
        [self snapToStartWithIndex:i];
    }
    self.expanded = NO;
    
    
    [self removeAllSubViews:^{
        
        completion();
    }];
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

#pragma mark -SphereModelViewDelegate
- (void)modelMenuViewDidTouchEnd:(id)menuView
{
    [self shrinkSubmenu:^{
        
    }];
}

@end
