//
//  LocalPhotoViewController.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalPhotoViewController.h"
#import "BXTPublicSetting.h"
#import "BXTGlobal.h"

@interface LocalPhotoViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation LocalPhotoViewController
{
    NSMutableArray *selectPhotoNames;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.selectPhotos==nil)
    {
        self.selectPhotos=[[NSMutableArray alloc] init];
        selectPhotoNames=[[NSMutableArray alloc] init];
    }
    else
    {
        selectPhotoNames=[[NSMutableArray alloc] init];
        for (id obj in self.selectPhotos )
        {
            if ([obj isKindOfClass:[ALAsset class]])
            {
                ALAsset *tempAsset = (ALAsset *)obj;
                [selectPhotoNames addObject:[tempAsset valueForProperty:ALAssetPropertyAssetURL]];
            }
            else
            {
                [selectPhotoNames addObject:obj];
            }
        }
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片",(unsigned long)self.selectPhotos.count];
    }
    
    self.collection.dataSource=self;
    self.collection.delegate=self;
    [self.collection registerNib:[UINib nibWithNibName:@"LocalPhotoCell" bundle:nil]  forCellWithReuseIdentifier:@"photocell"];
    
    [self navigationSetting];
    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ([group numberOfAssets] > 0)
        {
            [self showPhoto:group];
        }
        else
        {
            NSLog(@"读取相册完毕");
            //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock                                    failureBlock:nil];
}

/**
 *  设置导航条
 */
- (void)navigationSetting
{
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNAVIVIEWHEIGHT)];
    if ([BXTGlobal shareGlobal].isRepair)
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bars"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        naviView.image = [[UIImage imageNamed:@"Nav_Bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    }    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *navi_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    navi_titleLabel.backgroundColor = [UIColor clearColor];
    navi_titleLabel.font = [UIFont systemFontOfSize:18];
    navi_titleLabel.textColor = [UIColor whiteColor];
    navi_titleLabel.textAlignment = NSTextAlignmentCenter;
    navi_titleLabel.text = [NSString stringWithFormat:@"请选择图片"];
    [naviView addSubview:navi_titleLabel];
    
    UIButton *navi_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 44)];
    navi_leftButton.backgroundColor = [UIColor clearColor];
    [navi_leftButton setImage:[UIImage imageNamed:@"arrowBack"] forState:UIControlStateNormal];
    [navi_leftButton addTarget:self action:@selector(navigationLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:navi_leftButton];
    
    UIButton * nav_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 50, 44)];
    nav_rightButton.backgroundColor = [UIColor clearColor];
    [nav_rightButton setTitle:@"相册" forState:UIControlStateNormal];
    [nav_rightButton setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateNormal];
    [nav_rightButton addTarget:self action:@selector(albumAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:nav_rightButton];
}

- (void)navigationLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)albumAction
{
    LocalAlbumTableViewController *album=[[LocalAlbumTableViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:album];
    album.delegate=self;
    [self.navigationController presentViewController:nvc animated:YES completion:^(void){
        NSLog(@"开始");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photocell";
    LocalPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // load the asset for this cell
    ALAsset *asset=self.photos[indexPath.row];
    CGImageRef thumbnailImageRef = [asset thumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    [cell.img setImage:thumbnail];
    NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
    [cell.btnSelect setHidden:[selectPhotoNames indexOfObject:url]==NSNotFound];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LocalPhotoCell *cell=(LocalPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell.btnSelect.hidden)
    {
        if (self.isSinglePicture)
        {
            if (self.selectPhotos.count >= 1)
            {
                [self showMBP:@"只能选择1张图片" withBlock:nil];
                return;
            }
        }
        else
        {
            if (self.selectPhotos.count >= 3)
            {
                [self showMBP:@"最多选择3张图片" withBlock:nil];
                return;
            }
        }
        
        [cell.btnSelect setHidden:NO];
        ALAsset *asset=self.photos[indexPath.row];
        [self.selectPhotos addObject:asset];
        [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    else
    {
        [cell.btnSelect setHidden:YES];
        ALAsset *asset=self.photos[indexPath.row];
        for (ALAsset *a in self.selectPhotos) {
            NSString *str1=[asset valueForProperty:ALAssetPropertyAssetURL];
            NSString *str2=[a valueForProperty:ALAssetPropertyAssetURL];
            if([str1 isEqual:str2])
            {
                [self.selectPhotos removeObject:a];
                break;
            }
        }
        [selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    
    if(self.selectPhotos.count==0)
    {
        self.lbAlert.text=@"请选择照片";
    }
    else
    {
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%lu张照片",(unsigned long)self.selectPhotos.count];
    }
}

- (IBAction)btnConfirm:(id)sender
{
    if (self.selectPhotoDelegate!=nil)
    {
        [self.selectPhotoDelegate getSelectedPhoto:self.selectPhotos];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPhoto:(ALAssetsGroup *)album
{
    if(album!=nil)
    {
        if(self.currentAlbum==nil||![[self.currentAlbum valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[album valueForProperty:ALAssetsGroupPropertyName]])
        {
            self.currentAlbum=album;
            if (!self.photos) {
                _photos = [[NSMutableArray alloc] init];
            } else {
                [self.photos removeAllObjects];
                
            }
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [self.photos addObject:result];
                }else{
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.currentAlbum setAssetsFilter:onlyPhotosFilter];
            [self.currentAlbum enumerateAssetsUsingBlock:assetsEnumerationBlock];
            self.title = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
            [self.collection reloadData];
        }
    }
}

-(void)selectAlbum:(ALAssetsGroup *)album
{
    [self showPhoto:album];
}
@end
