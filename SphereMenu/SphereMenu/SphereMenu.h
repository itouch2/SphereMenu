//
//  SphereMenu.h
//  SphereMenu
//

#import <UIKit/UIKit.h>


typedef void (^SpherePickedMenu)(NSInteger index, UIView *menu);

#define key_sphere_menu_image   @"img"
#define key_sphere_menu_title   @"title"


@interface SphereMenu : UIView

+ (instancetype)showSphereMenuWithAnchorView:(UIView *)anchorView
                                 anchorImage:(UIImage *)anchorImg
                                 sphereMenus:(NSArray *(^)())menus
                                  pickedMenu:(SpherePickedMenu)completion;

@end
