#SphereMenu

SphereMenu is a fun menu powered by `UIDynamicAnimator`. Inspired by [Sphere](https://itunes.apple.com/hk/app/sphere-360o-photography/id335671384?mt=8).

## Usage
To use SpereMenu, create a `SpereMenu` like this

```objective-c
UIImage *startImage = [UIImage imageNamed:@"start"];
UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
UIImage *image2 = [UIImage imageNamed:@"icon-email"];
UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
NSArray *images = @[image1, image2, image3];
SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(160, 320) startImage:startImage submenuImages:images];
sphereMenu.delegate = self;
[self.view addSubview:sphereMenu];
```

## A Quick Peek
![screenshots](https://cloud.githubusercontent.com/assets/4316898/4098401/7cc3710e-301b-11e4-83ba-529349111c4d.gif)

## License

SphereMenu is available under the MIT license, see the LICENSE file for more information.     
