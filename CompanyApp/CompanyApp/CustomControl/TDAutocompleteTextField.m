//
//  TDAutocompleteTextField.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "TDAutocompleteTextField.h"

static NSObject<TDAutocompleteDataSource> *DefaultAutocompleteDataSource = nil;

@interface TDAutocompleteTextField ()

@property (nonatomic, strong) NSMutableArray *autocompleteArray;

@end

@implementation TDAutocompleteTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupAutocompleteTextField];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

- (void)setupAutocompleteTextField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark - Configuration

+ (void)setDefaultAutocompleteDataSource:(id)dataSource
{
    DefaultAutocompleteDataSource = dataSource;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.autocompleteLabel setFont:font];
}

#pragma mark - UIResponder

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

#pragma mark - Autocomplete Logic

- (void)textDidChange:(NSNotification*)notification
{
    [self refreshAutocompleteText];
}

- (void)refreshAutocompleteText
{
    if (!self.autocompleteDisabled)
    {
        id <TDAutocompleteDataSource> dataSource = nil;
        
        if ([self.autocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = (id <TDAutocompleteDataSource>)self.autocompleteDataSource;
        }
        else if ([DefaultAutocompleteDataSource respondsToSelector:@selector(textField:completionForPrefix:ignoreCase:)])
        {
            dataSource = DefaultAutocompleteDataSource;
        }
        
        if (dataSource)
        {
            self.autocompleteArray = [dataSource textField:self completionForPrefix:self.text ignoreCase:self.ignoreCase];
            if (self.autoDelegate && [self.autoDelegate respondsToSelector:@selector(refreshTableViewWithArray:)]) {
                [self.autoDelegate refreshTableViewWithArray:self.autocompleteArray];
            }
        }
    }
}

@end