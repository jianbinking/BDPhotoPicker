//
//  BDPhotoPickerGroupTableController.m
//  test_photo
//
//  Created by 王建斌 on 16/11/7.
//  Copyright © 2016年 王建斌. All rights reserved.
//

#import "BDPhotoPickerGroupTableController.h"
#import "BDPhotoGroupCell.h"
#import "BDPhotoPickerGroupManager.h"
#import "BDPhotoPickerController.h"
#import "BDPhotoPickerAssetsCollectionController.h"

@interface BDPhotoPickerGroupTableController ()<PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) BDPhotoPickerGroupManager *manager;

@end

@implementation BDPhotoPickerGroupTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"相册";
    [self setUpNavigationButtons];
    self.toolbarItems = [[self pickerController] customToolbarItems];
    self.manager = [[BDPhotoPickerGroupManager alloc]init];
    self.manager.delegate = [self pickerController].delegate;
    self.manager.groupVC = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BDPhotoGroupCell" bundle:NULL] forCellReuseIdentifier:@"BDPhotoGroupCell"];
    
    __weak BDPhotoPickerGroupTableController *wself = self;
    [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self];
    [self.manager loadCollectionsComplete:^(BOOL success, NSError *err) {
        __strong BDPhotoPickerGroupTableController *sself = wself;
        [sself.tableView reloadData];
        [sself setupGroup];
    }];
    [self.pickerController toggleDoneButton];
    
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigationButtons
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn:)];
}

- (void)leftBtn:(id)sender
{
    if ([self pickerController].delegate && [[self pickerController].delegate respondsToSelector:@selector(BDPhotoPickerControllerDidCancelPicking:)])
    {
        [[self pickerController].delegate BDPhotoPickerControllerDidCancelPicking:[self pickerController]];
    }
    [[self pickerController]dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setupGroup
{
    PHAssetCollection *collection = nil;
    for (PHAssetCollection *col in self.manager.arrCollections)
    {
        if ([self pickerController].delegate && [[self pickerController].delegate respondsToSelector:@selector(BDPhotoPickerController:isDefaultGroup:)])
        {
            if ([[self pickerController].delegate BDPhotoPickerController:[self pickerController] isDefaultGroup:col])
            {
                collection = col;
                break;
            }
        }
        else if ([self pickerController].strDefaultGroupName.length > 0)
        {
            if ([self.pickerController.strDefaultGroupName isEqualToString:col.localizedTitle])
            {
                collection = col;
                break;
            }
        }
    }
    if (collection)
    {
        BDPhotoPickerAssetsCollectionController *vc = [[BDPhotoPickerAssetsCollectionController alloc]init];
        vc.collection = collection;
        vc.hidesBottomBarWhenPushed = NO;
        [self.navigationController pushViewController:vc animated:NO];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.manager.arrCollections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBDPhotoGroupCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDPhotoGroupCell" forIndexPath:indexPath];
    
    PHAssetCollection *collection =  self.manager.arrCollections[indexPath.row];
    
    [cell setCollection:collection keyAsset:[self.manager keyAssetAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BDPhotoPickerAssetsCollectionController *vc = [[BDPhotoPickerAssetsCollectionController alloc]init];
    vc.collection = self.manager.arrCollections[indexPath.row];
    vc.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getters

- (BDPhotoPickerController*)pickerController
{
    return (BDPhotoPickerController*)self.navigationController.parentViewController;
}











@end
