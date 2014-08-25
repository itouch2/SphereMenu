//
//  SphereMenu.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "SphereMenu.h"

static const CGFloat angleOffset = M_PI_2 / 2;
static const CGFloat length = 80;

@interface SphereMenu () <UICollisionBehaviorDelegate>

@property (assign, nonatomic) NSUInteger count ;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *positions;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (strong, nonatomic) NSMutableArray *snaps;
@property (strong, nonatomic) NSMutableArray *taps;

@property (strong, nonatomic) UITapGestureRecognizer *tapOnStart;

@property (strong, nonatomic) id<UIDynamicItem> bumper;

@property (strong, nonatomic) UIImageView *start;

@property (assign, nonatomic) BOOL expanded;

@end


@implementation SphereMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage submenuImages:(NSArray *)images
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 320, 564);
        
        self.images = images;
        
        self.count = self.images.count;
        
        self.start = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.start.center = CGPointMake(160, 300);
        self.start.image = startImage;
        self.start.userInteractionEnabled = YES;
        
        self.tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(startTapped:)];
        [self.start addGestureRecognizer:self.tapOnStart];
        [self addSubview:self.start];
        
        self.snaps = [NSMutableArray array];
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    // setup the items
    for (int i = 0; i < self.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.images[i]];
        item.userInteractionEnabled = YES;
        [self addSubview:item];
        
        CGPoint position = [self centerForSphereAtIndex:i];
        item.center = self.start.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
    }
    
    [self bringSubviewToFront:self.start];
    
    // setup behavior and animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    for (int i = 0; i < self.count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.start.center];
        snap.damping = 0.25;
        [self.snaps addObject:snap];
    }
}

- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat firstAngle = M_PI + (M_PI_2 - angleOffset) + index * angleOffset;
    CGPoint startPoint = self.start.center;
    CGFloat x = startPoint.x + cos(firstAngle) * length;
    CGFloat y = startPoint.y + sin(firstAngle) * length;
    CGPoint center = CGPointMake(x, y);
    return center;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    NSUInteger index = [self.taps indexOfObject:gesture];
    if ([self.delegate respondsToSelector:@selector(sphereDidSelected:)]) {
        [self.delegate sphereDidSelected:(int)index];
    }
}

- (void)startTapped:(UITapGestureRecognizer *)gesture
{
    [self.animator removeBehavior:self.collision];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
    
    self.expanded = !self.expanded;
}

- (void)expandSubmenu
{
    [self removeSnapBehaviors];
    
    for (int i = 0; i < self.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
}

- (void)shrinkSubmenu
{
    [self removeSnapBehaviors];

    for (int i = 0; i < self.count; i++) {
        [self snapToStartWithIndex:i];
    }
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        [self.animator addBehavior:self.collision];
        
        NSUInteger index = [self.items indexOfObject:touchedView];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.start.center];
    snap.damping = 0.25;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = 0.25;
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

@end
