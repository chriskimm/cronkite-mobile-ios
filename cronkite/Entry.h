#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Entry : NSManagedObject

@property (nonatomic, copy) NSString *text1;
@property (nonatomic, retain) NSDate *date;

-(id)initWithText:(NSString *)text1;
-(id)initWithText:(NSString *)text1 andDate:(NSDate *)date;

@end
