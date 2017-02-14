//
//  DocManagerCellFooterView.m
//  KaoTiBi
//
//  Created by linkapp on 13/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocManagerCellFooterView.h"
#import "DocMgrCellFooterLayout.h"
#import "DocCollectionViewCell.h"

#define kCollectionCellIdentifier @"kCollectionCellIdentifier"

@interface DocManagerCellFooterView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectitonView;

@end

@implementation DocManagerCellFooterView


- (void)setupCollectionView{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = (screenSize.width - (kRow + 1) * kLeftMagin) / kRow;
    CGFloat collectionHeight = itemWidth + 2*kLeftMagin;
    NSInteger itemCount = self.documents.count;
    
    int lineCount = (int)(itemCount / kRow);
    if (itemCount % kRow) {
        lineCount +=1;
    }
    
    if (itemCount > kRow) {
        collectionHeight = lineCount * itemWidth + 2 *kLeftMagin + kItemMinLineSpacing * lineCount;
    }
    CGRect collectionRect = CGRectMake(0, 0, screenSize.width, collectionHeight);
    
    if (_collectitonView == nil) {
        DocMgrCellFooterLayout *layout = [[DocMgrCellFooterLayout alloc] init];
        
        _collectitonView = [[UICollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
        [_collectitonView registerNib:[UINib nibWithNibName:@"DocCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCollectionCellIdentifier];
        _collectitonView.delegate = self;
        _collectitonView.dataSource = self;
        _collectitonView.scrollEnabled = NO;
        _collectitonView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_collectitonView];
    }else{
        _collectitonView.frame = collectionRect;
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
     [self.collectitonView reloadData];
}

-(void)setDocuments:(NSArray *)documents{
    _documents = documents;
    [self setupCollectionView];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Document *doc = self.documents[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectedSectionIndex:withDocment:)]) {
        [self.delegate didSelectedSectionIndex:self.indexSection withDocment:doc];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.documents.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DocCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = (screenSize.width - (kRow + 1) * kLeftMagin) / kRow;
    cell.itemWidth = itemWidth;
    cell.document = self.documents[indexPath.row];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
