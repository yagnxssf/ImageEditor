//
//  ImageEditorTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "ImageEditorTool.h"
#import "ImageEditorToolCell.h"

@interface ImageEditorTool() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy) NSArray *dataArr;

@end

@implementation ImageEditorTool

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr {
    if ([super init]) {
        self.dataArr = dataArr;
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(82, 82);
    if (self.dataArr.count <= 3) {
        CGFloat itemSpace = (ScreenW - (82*self.dataArr.count))/(self.dataArr.count+1);
        layout.minimumInteritemSpacing = itemSpace;
        layout.minimumLineSpacing = itemSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, itemSpace, 0, itemSpace);
    } else {
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[ImageEditorToolCell class] forCellWithReuseIdentifier:@"ImageEditorToolCell"];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageEditorToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageEditorToolCell" forIndexPath:indexPath];
    cell.cellDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageEditorToolDidSelect:)]) {
        [self.delegate imageEditorToolDidSelect:indexPath];
    }
}

@end
