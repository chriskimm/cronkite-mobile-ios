#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Item : NSManagedObject

typedef enum {
  kSynced,
  kQueued
} syncState;

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSDate *modified;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) int syncStatus;

-(id)initWithText:(NSString *)text;
-(id)initWithText:(NSString *)text andDate:(NSDate *)date;

@end
