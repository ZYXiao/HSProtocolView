#import <UIKit/UIKit.h>

typedef enum {
    HSProtocolViewLayoutDirectionHorizontal = 0,
    HSProtocolViewLayoutDirectionVertical
    
}HSProtocolViewLayoutDirection;

@protocol HSProtocolViewDelegate;

@interface HSProtocolView : UIView

@property (nonatomic,weak) id <HSProtocolViewDelegate>delegate;

/**
 初始化创建协议视图

 @param protocolNames 协议名称数组
 @param protocolPrefix 协议前缀
 @param checkboxAgreeImage 同意的checkbox图片
 @param checkboxDisagreeImage 不同意的checkbox图片
 @param layoutDirection 布局方向，目前支持水平方向（不换行）和垂直方向布局
 @return (HSProtocolView)
 */
- (id)initWithProtocolNames:(NSArray <NSString *>* _Nonnull)protocolNames
             protocolPrefix:(NSString * _Nonnull)protocolPrefix
         checkboxAgreeImage:(UIImage * _Nonnull)checkboxAgreeImage
      checkboxDisagreeImage:(UIImage * _Nonnull)checkboxDisagreeImage
            layoutDirection:(HSProtocolViewLayoutDirection)layoutDirection;

/**
 用户是否同意协议

 @return (BOOL)
 */
- (BOOL)isAgreedProtocol;

@end


@protocol HSProtocolViewDelegate <NSObject>
@optional
/**
 用户点击了某个协议

 @param protocolView 协议视图
 @param protocolName 协议名称，如《投资协议》
 */
- (void)protocolView:(HSProtocolView *)protocolView didClickedProtocolNamed:(NSString *)protocolName;

@end
