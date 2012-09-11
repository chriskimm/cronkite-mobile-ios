#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Item : NSManagedObject

typedef enum {
  kSynced,
  kQueued
} syncState;

@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSDate *updated_at;
@property (nonatomic, retain) NSNumber *sync_status;
@property (nonatomic, retain) NSNumber *delete_status;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSSet *locations;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;
- (NSDictionary *)dataDict;

@end
