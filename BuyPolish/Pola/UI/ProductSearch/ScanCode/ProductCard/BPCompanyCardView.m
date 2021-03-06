#import "BPCompanyCardView.h"
#import "BPMainProggressView.h"
#import "UILabel+BPAdditions.h"
#import "BPTheme.h"

NSInteger const CARD_PADDING = 10;
int const CARD_SEPARATOR_HEIGHT = 1;
int const CARD_REPORT_MARGIN = 14;
int const CARD_REPORT_BUTTON_HEIGHT = 30;
int const CARD_CONTENT_PROGRESS_IN_HEADER = 6;

@interface BPCompanyCardView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingProgressView;
@property(nonatomic, readonly) BPMainProggressView *mainProgressView;
@property(nonatomic, readonly) BPCompanyContentView *contentView;
@property(nonatomic, readonly) UIButton *reportProblemButton;
@property(nonatomic, readonly) UILabel *reportInfoLabel;
@property(nonatomic, readonly) UIView *separatorView;
@end

@implementation BPCompanyCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme clearColor];

        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = NO;
        self.layer.shadowRadius = 1.f;
        self.layer.shadowOpacity = 0.2f;

        _loadingProgressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingProgressView sizeToFit];
        [self addSubview:_loadingProgressView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BPTheme titleFont];
        _titleLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_titleLabel];

        _mainProgressView = [[BPMainProggressView alloc] initWithFrame:CGRectZero];
        [_mainProgressView sizeToFit];
        [self addSubview:_mainProgressView];

        _contentView = [[BPCompanyContentView alloc] initWithFrame:CGRectZero];
        _contentView.padding = CARD_PADDING;
        [self addSubview:_contentView];

        _reportProblemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportProblemButton addTarget:self action:@selector(didTapReportProblem) forControlEvents:UIControlEventTouchUpInside];
        _reportProblemButton.titleLabel.font = [BPTheme buttonFont];
        [_reportProblemButton sizeToFit];
        [self addSubview:_reportProblemButton];

        _reportInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reportInfoLabel.numberOfLines = 3;
        _reportInfoLabel.font = [BPTheme normalFont];
        _reportInfoLabel.textColor = [BPTheme defaultTextColor];
        [_reportInfoLabel sizeToFit];
        [self addSubview:_reportInfoLabel];

        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CARD_SEPARATOR_HEIGHT)];
        _separatorView.backgroundColor = [BPTheme lightBackgroundColor];
        [self addSubview:_separatorView];
    }

    return self;
}

- (void)didTapReportProblem {
    [self.delegate didTapReportProblem:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const int verticalTitleSpace = (const int) (self.titleHeight - CARD_CONTENT_PROGRESS_IN_HEADER);
    const int widthWithPadding = (const int) (CGRectGetWidth(self.bounds) - 2 * CARD_PADDING);

    CGRect rect = self.titleLabel.frame;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    rect.size.width = widthWithPadding;
    self.titleLabel.frame = rect;

    rect = self.loadingProgressView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - CARD_PADDING - CGRectGetWidth(self.loadingProgressView.bounds);
    rect.origin.y = verticalTitleSpace / 2 - CGRectGetHeight(rect) / 2;
    self.loadingProgressView.frame = rect;

    rect = self.mainProgressView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = verticalTitleSpace;
    self.mainProgressView.frame = rect;

    rect = self.reportProblemButton.frame;
    rect.size.height = CARD_REPORT_BUTTON_HEIGHT;
    rect.size.width = widthWithPadding;
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - CARD_REPORT_MARGIN - CGRectGetHeight(rect);
    self.reportProblemButton.frame = rect;

    rect = self.reportInfoLabel.frame;
    rect.size.width = widthWithPadding;
    rect.size.height = [self.reportInfoLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = CARD_PADDING;
    rect.origin.y = CGRectGetMinY(self.reportProblemButton.frame) - CARD_REPORT_MARGIN - CGRectGetHeight(rect);
    self.reportInfoLabel.frame = rect;

    rect = self.separatorView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMinY(self.reportInfoLabel.frame) - 15 - CGRectGetHeight(rect);
    self.separatorView.frame = rect;

    rect = self.contentView.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.size.height = CGRectGetMinY(self.separatorView.frame) - CGRectGetMaxY(self.mainProgressView.frame);
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMaxY(self.mainProgressView.frame);
    self.contentView.frame = rect;
}

- (void)setContentType:(CompanyContentType)contentType {
    [self.contentView setContentType:contentType];

    BOOL loading = contentType == CompanyContentTypeLoading;
    self.reportProblemButton.hidden = loading;
    self.reportInfoLabel.hidden = loading;
    self.separatorView.hidden = loading;
    if (loading) {
        [self.loadingProgressView startAnimating];
    } else {
        [self.loadingProgressView stopAnimating];
    }
}

- (void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setMainPercent:(CGFloat)mainPercent {
    self.mainProgressView.progress = mainPercent;
    [self.mainProgressView setNeedsLayout];
}

- (void)setCapitalPercent:(NSNumber *)capitalPercent {
    [self.contentView setCapitalPercent:capitalPercent];
}

- (void)setWorkers:(NSNumber *)workers {
    [self.contentView setWorkers:workers];
}

- (void)setRnd:(NSNumber *)rnd {
    [self.contentView setRnd:rnd];
}

- (void)setRegistered:(NSNumber *)registered {
    [self.contentView setRegistered:registered];
}

- (void)setNotGlobal:(NSNumber *)notGlobal {
    [self.contentView setNotGlobal:notGlobal];
}

- (void)setDescr:(NSString *)description {
    [self.contentView setDescr:description];
}

- (void)setAltText:(NSString *)altText {
    [self.contentView setAltText:altText];
}

- (void)setCardType:(CardType)type {
    if (type == CardTypeGrey) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];
        self.mainProgressView.backgroundColor = [BPTheme strongBackgroundColor];
    } else {
        self.backgroundColor = [BPTheme clearColor];
        self.mainProgressView.backgroundColor = [BPTheme lightBackgroundColor];
    }

    [self.contentView setCardType:type];
}

- (void)setReportButtonType:(ReportButtonType)type {
    if (type == ReportButtonTypeRed) {
        [self.reportProblemButton setTitleColor:[BPTheme clearColor] forState:UIControlStateNormal];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateNormal];
    } else {
        self.reportProblemButton.layer.borderColor = [[BPTheme actionColor] CGColor];
        self.reportProblemButton.layer.borderWidth = 1;
        [self.reportProblemButton setTitleColor:[BPTheme actionColor] forState:UIControlStateNormal];
        [self.reportProblemButton setTitleColor:[BPTheme clearColor] forState:UIControlStateHighlighted];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.reportProblemButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateHighlighted];
    }
}

- (void)setReportButtonText:(NSString *)text {
    [self.reportProblemButton setTitle:[text uppercaseString] forState:UIControlStateNormal];
    [self.reportProblemButton sizeToFit];
}

- (void)setReportText:(NSString *)text {
    self.reportInfoLabel.text = text;
    [self.reportInfoLabel sizeToFit];
}

- (void)setFocused:(BOOL)focused {
    [self.contentView flashScrollIndicators];
}

@end