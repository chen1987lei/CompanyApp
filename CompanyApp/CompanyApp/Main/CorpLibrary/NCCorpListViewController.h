//
//  NCCorpListViewController.h
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "TDViewController.h"

@interface NCCorpListViewController : TDViewController

@property(nonatomic,strong) NCBaseModel *currentModel;
@property(nonatomic,strong) NSArray *childData;
@end
