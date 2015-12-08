//
//  TDAutocompleteTextField.h
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TDAutocompleteTextFieldDelegate <NSObject>

-(void)refreshTableViewWithArray:(NSMutableArray *)array;

@end

@class  TDAutocompleteTextField;

@protocol TDAutocompleteDataSource <NSObject>

- (NSMutableArray*)textField:(TDAutocompleteTextField*)textField
         completionForPrefix:(NSString*)prefix
                  ignoreCase:(BOOL)ignoreCase;

@end

@interface TDAutocompleteTextField : UITextField

- (id)initWithFrame:(CGRect)frame;

/*
 * Autocomplete behavior
 */
@property (nonatomic, assign) NSUInteger autocompleteType; // Can be used by the dataSource to provide different types of autocomplete behavior
@property (nonatomic, assign) BOOL autocompleteDisabled;
@property (nonatomic, assign) BOOL ignoreCase;

@property(nonatomic,assign)id<TDAutocompleteTextFieldDelegate> autoDelegate;

/*
 * Configure text field appearance
 */
@property (nonatomic, strong) UILabel *autocompleteLabel;
- (void)setFont:(UIFont *)font;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;
@property (nonatomic, weak) id<TDAutocompleteDataSource> autocompleteDataSource;
+ (void)setDefaultAutocompleteDataSource:(id<TDAutocompleteDataSource>)dataSource;


@end
