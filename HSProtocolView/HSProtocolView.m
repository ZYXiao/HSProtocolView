#import "HSProtocolView.h"
#import "Masonry.h"

@interface HSProtocolView ()

@property (nonatomic,strong) UIImage *checkboxAgreeImage;
@property (nonatomic,strong) UIImage *checkboxDisagreeImage;
@property (nonatomic,strong) NSArray <NSString *>*protocolNames;
@property (nonatomic,strong) NSString *protocolPrefix;
@property (nonatomic,strong) NSString *protocolDivision; // 这个值只在水平方向布局的时候有效
@property (nonatomic,assign) HSProtocolViewLayoutDirection layoutDirection;
@property (nonatomic,strong) UIButton *checkbox;

@end

@implementation HSProtocolView

#pragma mark - obj life cycle
- (id)initWithProtocolNames:(NSArray <NSString *>* _Nonnull)protocolNames
             protocolPrefix:(NSString * _Nonnull)protocolPrefix
         checkboxAgreeImage:(UIImage * _Nonnull)checkboxAgreeImage
      checkboxDisagreeImage:(UIImage * _Nonnull)checkboxDisagreeImage
            layoutDirection:(HSProtocolViewLayoutDirection)layoutDirection {
    return [self initWithProtocolNames:protocolNames protocolPrefix:protocolPrefix protocolDivision:nil checkboxAgreeImage:checkboxAgreeImage checkboxDisagreeImage:checkboxDisagreeImage layoutDirection:layoutDirection];
}

- (id)initWithProtocolNames:(NSArray <NSString *>*)protocolNames
             protocolPrefix:(NSString *)protocolPrefix
           protocolDivision:(NSString *)protocolDivision
         checkboxAgreeImage:(UIImage *)checkboxAgreeImage
      checkboxDisagreeImage:(UIImage *)checkboxDisagreeImage
            layoutDirection:(HSProtocolViewLayoutDirection)layoutDirection {
    if (self = [super init]) {
        NSAssert(protocolNames.count, @"协议名称数组不能为空");
        _protocolNames = protocolNames;
        _protocolPrefix = protocolPrefix;
        _protocolDivision = protocolDivision;
        _checkboxAgreeImage = checkboxAgreeImage;
        _checkboxDisagreeImage = checkboxDisagreeImage;
        _layoutDirection = layoutDirection;
        if (layoutDirection == HSProtocolViewLayoutDirectionHorizontal) {
            [self setup_horizontal];
        }
        else {
            [self setup_vertical];
        }
    }
    return self;
}

#pragma mark - load
- (void)setup_horizontal {
    // contentView
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset([self checkboxSize].width * 0.5);
        make.size.mas_equalTo(CGSizeMake([self contentSizeOfHorizontalLayout].width + 1, [self contentSizeOfHorizontalLayout].height + 1));
    }];
    // prefixLabel
    UILabel *prefixLabel = [[UILabel alloc] init];
    prefixLabel.text = _protocolPrefix;
    prefixLabel.font = [UIFont systemFontOfSize:14.0];
    prefixLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [contentView addSubview:prefixLabel];
    [prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.centerY.equalTo(contentView);
        make.height.mas_equalTo(14);
    }];
    // protocolBtns&&divisionLabels
    NSMutableArray <UILabel *>*extraLabels = [NSMutableArray arrayWithObject:prefixLabel];
    for (int i = 0; i < _protocolNames.count; i ++) {
        // protocolBtn
        UIButton *protocolBtn = [self protocolBtnNamed:_protocolNames[i]];
        [contentView addSubview:protocolBtn];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(extraLabels[i].mas_right);
            make.centerY.equalTo(contentView);
            make.height.mas_equalTo(14);
        }];
        if (i != (_protocolNames.count - 1)) {
            // divisionLabel
            UILabel *divisionLabel = [[UILabel alloc] init];
            divisionLabel.text = _protocolDivision;
            divisionLabel.font = [UIFont systemFontOfSize:14.0];
            divisionLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [contentView addSubview:divisionLabel];
            [divisionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(protocolBtn.mas_right);
                make.centerY.equalTo(contentView);
                make.height.mas_equalTo(14);
            }];
            [extraLabels addObject:divisionLabel];
        }
    }
    // checkbox
    _checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkbox.backgroundColor = [UIColor clearColor];
    [_checkbox addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_checkbox setImage:_checkboxDisagreeImage forState:UIControlStateNormal];
    [_checkbox setImage:_checkboxAgreeImage forState:UIControlStateSelected];
    _checkbox.selected = YES;
    [self addSubview:_checkbox];
    [_checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(contentView.mas_left);
        make.size.mas_equalTo([self checkboxSize]);
    }];
}

- (void)setup_vertical {
    // contentView
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset([self checkboxSize].width * 0.5);
        make.size.mas_equalTo(CGSizeMake([self contentSizeOfVerticalLayout].width + 1, [self contentSizeOfVerticalLayout].height + 1));
    }];
    // prefixLabel
    UILabel *prefixLabel = [[UILabel alloc] init];
    prefixLabel.text = _protocolPrefix;
    prefixLabel.font = [UIFont systemFontOfSize:14.0];
    prefixLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [contentView addSubview:prefixLabel];
    [prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.mas_equalTo(14);
    }];
    // protocolBtns
    NSMutableArray <UIButton *>*protocolBtns = [NSMutableArray array];
    CGFloat protocolPadding = 4;
    for (int i = 0; i < _protocolNames.count; i ++) {
        // protocolBtn
        UIButton *protocolBtn = [self protocolBtnNamed:_protocolNames[i]];
        [contentView addSubview:protocolBtn];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(prefixLabel.mas_right);
            make.height.mas_equalTo(14);
            if (protocolBtns.count > 0) {
                make.top.equalTo(protocolBtns[i-1].mas_bottom).offset(protocolPadding);
            }
            else {
                make.top.equalTo(contentView);
            }
        }];
        [protocolBtns addObject:protocolBtn];
    }
    // checkbox
    _checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkbox.backgroundColor = [UIColor clearColor];
    [_checkbox addTarget:self action:@selector(checkboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_checkbox setImage:_checkboxDisagreeImage forState:UIControlStateNormal];
    [_checkbox setImage:_checkboxAgreeImage forState:UIControlStateSelected];
    _checkbox.selected = YES;
    [self addSubview:_checkbox];
    [_checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(prefixLabel);
        make.right.equalTo(contentView.mas_left);
        make.size.mas_equalTo([self checkboxSize]);
    }];
}

#pragma mark - actions
- (void)protocolBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(protocolView:didClickedProtocolNamed:)]) {
        NSString *protocolName = ((UIButton *)sender).titleLabel.text;
        [self.delegate protocolView:self didClickedProtocolNamed:protocolName];
    }
}

- (void)checkboxClicked:(id)sender {
    self.checkbox.selected = !self.checkbox.selected;
}

#pragma mark - calculate size
- (CGSize)checkboxSize {
    CGSize size = CGSizeZero;
    size.width = (_checkboxAgreeImage.size.width > _checkboxDisagreeImage.size.width ? _checkboxAgreeImage.size.width : _checkboxDisagreeImage.size.width);
    size.height = (_checkboxAgreeImage.size.height > _checkboxDisagreeImage.size.height ? _checkboxAgreeImage.size.height : _checkboxDisagreeImage.size.height);
    size.width = size.width + 10; // 添加宽度，增大点击范围
    size.height = size.height + 10; // 添加高度，增大点击范围
    return size;
}

- (CGSize)contentSizeOfHorizontalLayout {
    NSMutableString *string0 = [[NSMutableString alloc] init];
    [string0 appendString:_protocolPrefix];
    for (NSString *protocolName in _protocolNames) {
        if (protocolName.length) {
            [string0 appendString:protocolName];
            if (_protocolDivision.length) [string0 appendString:_protocolDivision];
        }
    }
    NSString *string1 = [string0 substringToIndex:(string0.length - 1)];
    return [string1 boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                 context:nil].size;
}

- (CGSize)contentSizeOfVerticalLayout {
    CGFloat protocolPadding = 4;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    NSString *longestProtocolName = @"";
    for (NSString *protocolName in _protocolNames) {
        if (protocolName.length > longestProtocolName.length) {
            longestProtocolName = protocolName;
        }
        contentHeight += (14.0 + protocolPadding);
    }
    contentHeight -= protocolPadding;
    NSString *temp = [NSString stringWithFormat:@"%@%@",_protocolPrefix,longestProtocolName];
    contentWidth = [temp boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                      context:nil].size.width;
    return CGSizeMake(contentWidth, contentHeight);
}

#pragma mark -
- (BOOL)isAgreedProtocol {
    if (self.checkbox.selected) {
        return YES;
    }
    return NO;
}

- (UIButton *)protocolBtnNamed:(NSString *)protocolName {
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [protocolBtn setTitle:protocolName forState:UIControlStateNormal];
    [protocolBtn setTitle:protocolName forState:UIControlStateHighlighted];
    [protocolBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:170/255.0 blue:255/255.0 alpha:1.0]
                      forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[[UIColor colorWithRed:0/255.0 green:170/255.0 blue:255/255.0 alpha:1.0] colorWithAlphaComponent:0.7]
                      forState:UIControlStateHighlighted];
    [protocolBtn addTarget:self action:@selector(protocolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return protocolBtn;
}


@end
