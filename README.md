#SphereMenu

SphereMenu is a fun menu powered by `UIDynamicAnimator`. Inspired by [Sphere](https://itunes.apple.com/hk/app/sphere-360o-photography/id335671384?mt=8).

## Usage
To use SpereMenu, create a `SpereMenu` like this

```objective-c
[SphereMenu showSphereMenuWithAnchorView:self.btn
anchorImage:[UIImage imageNamed:@"picked"]
sphereMenus:^NSArray *{

UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
UIImage *image2 = [UIImage imageNamed:@"icon-email"];
UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];

UIImage *image4 = [UIImage imageNamed:@"icon-twitter"];
UIImage *image5 = [UIImage imageNamed:@"icon-email"];
UIImage *image6 = [UIImage imageNamed:@"icon-facebook"];

NSArray *images = @[@{key_sphere_menu_image:image1, key_sphere_menu_title:@"我想买"},
@{key_sphere_menu_image:image2, key_sphere_menu_title:@"大规模有"},
@{key_sphere_menu_image:image3, key_sphere_menu_title:@"暗黑破神"},
@{key_sphere_menu_image:image4, key_sphere_menu_title:@"大规木有"},
@{key_sphere_menu_image:image5, key_sphere_menu_title:@"大规木有"},
@{key_sphere_menu_image:image6, key_sphere_menu_title:@"模有木有"}];

return images;
}
pickedMenu:^(NSInteger index, UIView *menu) {

NSLog(@"picked index = %ld", index);
}];
```

## A Quick Peek
![screenshots](https://cloud.githubusercontent.com/assets/4316898/4098401/7cc3710e-301b-11e4-83ba-529349111c4d.gif)

## License

SphereMenu is available under the MIT license, see the LICENSE file for more information.     
