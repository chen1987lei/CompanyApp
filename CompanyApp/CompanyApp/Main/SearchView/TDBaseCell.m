//
//  TDBaseCell.m
//  Tudou
//
//  Created by CL7RNEC on 15/3/31.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBaseCell.h"
#import "TDBaseHorizontalCellView.h"
#import "TDBaseVerticalCellView.h"
#import "TDBaseBigCellView.h"
#import "TDHomeModel.h"

@interface TDBaseCell()

@property (nonatomic,assign) TDCellType cellType;


@end

@implementation TDBaseCell
#pragma mark - life cycle
-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
      withCellType:(TDCellType)cellType{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        _cellType=cellType;
        _arrCell=[[NSMutableArray alloc]initWithCapacity:1];
        self.backgroundColor=RGBS(255);
        self.opaque=YES;
        self.exclusiveTouch=YES;
        switch (_cellType) {
            case cellTypeBigOne:
                [self initCellBigOne];
                break;
            case cellTypeHorizontalTwo:
                [self initCellHorizontalTwo];
                break;
            case cellTypeVerticalThree:
                [self initCellVerticalThree];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)initCellBigOne{
    TDBaseBigCellView *cellView=[[TDBaseBigCellView alloc] initWithFrame:CGRectMake(kBIG_MARGIN_X, kBIG_MARGIN_Y,kBIG_WIDTH, kBIG_HEIGHT)];
    [self addSubview:cellView];
    [_arrCell addObject:cellView];
}

-(void)initCellHorizontalTwo{
    TDBaseHorizontalCellView *cellViewLeft=[[TDBaseHorizontalCellView alloc] initWithFrame:CGRectMake(kHORIZONTAL_MARGIN_X, kHORIZONTAL_MARGIN_Y, kHORIZONTAL_WIDTH, kHORIZONTAL_HEIGHT)];
    [self addSubview:cellViewLeft];
    [_arrCell addObject:cellViewLeft];
    TDBaseHorizontalCellView *cellViewRight=[[TDBaseHorizontalCellView alloc] initWithFrame:CGRectMake(cellViewLeft.right+kHORIZONTAL_MARGIN_RIGHT_X, kHORIZONTAL_MARGIN_Y, kHORIZONTAL_WIDTH, kHORIZONTAL_HEIGHT)];
    [self addSubview:cellViewRight];
    [_arrCell addObject:cellViewRight];
}

-(void)initCellVerticalThree{
    TDBaseVerticalCellView *cellViewLeft=[[TDBaseVerticalCellView alloc] initWithFrame:CGRectMake(kVERTICAL_MARGIN_X-1, kVERTICAL_MARGIN_Y, kVERTICAL_WIDTH, kVERTICAL_HEIGHT)];
    [self addSubview:cellViewLeft];
    [_arrCell addObject:cellViewLeft];
    TDBaseVerticalCellView *cellViewMiddle=[[TDBaseVerticalCellView alloc] initWithFrame:CGRectMake(cellViewLeft.right+kVERTICAL_MARGIN_RIGHT_X, kVERTICAL_MARGIN_Y, kVERTICAL_WIDTH, kVERTICAL_HEIGHT)];
    [self addSubview:cellViewMiddle];
    [_arrCell addObject:cellViewMiddle];
    TDBaseVerticalCellView *cellViewRight=[[TDBaseVerticalCellView alloc] initWithFrame:CGRectMake(cellViewMiddle.right+kVERTICAL_MARGIN_RIGHT_X, kVERTICAL_MARGIN_Y, kVERTICAL_WIDTH, kVERTICAL_HEIGHT)];
    [self addSubview:cellViewRight];
    [_arrCell addObject:cellViewRight];
    
  
    if([UIDevice currentDevice].systemVersion.integerValue <7)
    {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - setData
-(void)setArrList:(NSArray *)arrList{
    if (![arrList isKindOfClass:[NSArray class]]) {
        return;
    }
    _arrList = arrList;
    if ([_arrList count]<[_arrCell count]) {
        NSRange range = NSMakeRange([_arrList count],[_arrCell count]-[_arrList count]);
        NSArray *hiddenLayers = [_arrCell subarrayWithRange:range];
        for (UIView *view in hiddenLayers) {
            view.hidden = YES;
        }
    }
    for (int i = 0;i<[_arrList count];i++) {
        if (i+1>[_arrCell count]) {
            break;
        }
        else{
            TDHomeModel *video = _arrList[i];
            TDBaseCellView *cellView=_arrCell[i];
            cellView.title = video.title;
            cellView.subTitle = video.subTitle;
            cellView.imgBottomTitle = video.imageBottomTitle;
            cellView.imgBottomSubTitle = video.imageBottomSubTitle;
            cellView.imgUrl = video.imageUrl;
            cellView.imgCornerUrl = video.cornerImgUrl;
            cellView.hidden=NO;
            [cellView refreshCellView];
        }
    }    
}
#pragma mark - other
+(float)cellHeight:(TDCellType)cellType{
    float height=0;
    switch (cellType) {
        case cellTypeBigOne:
            height=kBIG_HEIGHT;
            break;
        case cellTypeHorizontalTwo:
            height=kHORIZONTAL_HEIGHT;
            break;
        case cellTypeVerticalThree:
            height=kVERTICAL_HEIGHT;
            break;
        case cellTypeOther:
            
            break;
        default:
            break;
    }
    return height;
}
#pragma mark - action
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(viewTouchWithIndexPath)])
    {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        NSInteger count = [_arrList count] < [_arrCell count] ? [_arrList count] : [_arrCell count];
        for (NSInteger i=0;i<count;i++) {
            UIView *view = [_arrCell objectAtIndex:i];
            if (CGRectContainsPoint(view.frame, point)) {
                NSIndexPath* indexpath = nil;
                if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                    indexpath = [(UITableView*)self.superview indexPathForCell:self];
                }else{
                    indexpath = [(UITableView*)self.superview.superview indexPathForCell:self];
                }
                if (indexpath) {
                    [self.delegate viewTouchWithIndexPath:indexpath];
                }
            }
        }
    }
}
@end
