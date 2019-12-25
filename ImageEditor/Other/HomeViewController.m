//
//  HomeViewController.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/16.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "HomeViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "ImagesEditorViewController.h"
#import "SettingViewController.h"


@interface HomeViewController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *camera;
@property (weak, nonatomic) IBOutlet UILabel *beautity;
@property (weak, nonatomic) IBOutlet UILabel *setting;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleStrBottom;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.camera.text = NSLocalizedString(@"相机", nil);
    self.beautity.text = NSLocalizedString(@"美化", nil);
    self.setting.text = NSLocalizedString(@"设置", nil);
    
    if (IS_IPAD) {
        self.titleStrBottom.constant = 20;
    } else if (iPhone5 || iPhone4s) {
        self.titleStrBottom.constant = 20;
    }

}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        NSLog(@"imageInfo = %@",info);
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
        }];
    }
    PAWeakSelf
    [self dismissViewControllerAnimated:YES completion:^{
        ImagesEditorViewController *editorVC = [[ImagesEditorViewController alloc] init];
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        UIImage *lastImg;
        if (image.imageOrientation == 3) {
            lastImg = [HImageUtility image:image rotation:3];
        }
        editorVC.originArr = @[lastImg];
        [weakSelf presentViewController:editorVC animated:YES completion:^{
            
        }];
    }];
}

- (IBAction)cameraAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
//    picker.allowsEditing = YES; //可编辑
    
    //判断是否可以打开照相机
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //摄像头
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"没有摄像头");
    }
}
- (IBAction)beautityAction:(id)sender {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:10000 delegate:self];
            picker.naviBgColor = RGB(20, 20, 20);
            picker.isSelectOriginalPhoto = YES;
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}
- (IBAction)settingAction:(id)sender {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    ImagesEditorViewController *editorVC = [[ImagesEditorViewController alloc] init];
//    SABaseNaviController *nav = [[SABaseNaviController alloc] initWithRootViewController:editorVC];
//    PHAsset *asset = assets.firstObject;
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//    options.networkAccessAllowed = YES;
//    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//        NSLog(@"imageData length = %ld",imageData.length);
//    }];
    editorVC.originArr = photos;
    [self presentViewController:editorVC animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
