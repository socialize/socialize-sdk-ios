//
//  entities.m
//  Socialize
//
//  Created by Nathaniel Griswold on 6/28/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "entities.h"
#import <Socialize/Socialize.h>
#import <SZJSONKit/JSONKit.h>

@implementation entities

// begin-create-snippet

- (void)createEntity {
    SZEntity *entity = [SZEntity entityWithKey:@"my_key" name:@"An Entity"];
    [SZEntityUtils addEntity:entity success:^(id<SZEntity> entity) {
        NSLog(@"Created entity %@/%d", [entity key], [entity objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-create-snippet

// begin-get-snippet

- (void)getEntity {
    [SZEntityUtils getEntityWithKey:@"my_key" success:^(id<SZEntity> entity) {
        NSLog(@"Retrieved entity %@/%d", [entity key], [entity objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-get-snippet

// begin-get-all-snippet

- (void)getAllEntitiesForApplication {
    [SZEntityUtils getEntitiesWithFirst:[NSNumber numberWithInteger:0] last:[NSNumber numberWithInteger:50] success:^(NSArray *entities) {
        for (id<SZEntity> entity in entities) {
            NSLog(@"Retrieved entity %@/%d", [entity key], [entity objectID]);            
        }
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-get-all-snippet

// begin-get-popular-snippet

- (void)getPopularEntitiesForApplication {
    [SZEntityUtils getEntitiesWithSorting:SZResultSortingPopularity first:nil last:nil success:^(NSArray *entities) {
        for (id<SZEntity> entity in entities) {
            NSLog(@"Retrieved entity %@/%d", [entity key], [entity objectID]);            
        }
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-get-popular-snippet

// begin-get-many-snippet

- (void)getMultipleEntitiesById {
    NSArray *ids = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
    [SZEntityUtils getEntitiesWithIds:ids success:^(NSArray *entities) {
        for (id<SZEntity> entity in entities) {
            NSLog(@"Retrieved entity %@/%d", [entity key], [entity objectID]);            
        }
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-get-many-snippet


// begin-print-stats-snippet

- (void)getUserStats {
    [SZEntityUtils getEntitiesWithFirst:[NSNumber numberWithInteger:0] last:[NSNumber numberWithInteger:50] success:^(NSArray *entities) {
        for (id<SZEntity> entity in entities) {
            
            // userActionSummary contains information about how the authenticated user has acted on this entity
            NSDictionary *userActions = [entity userActionSummary];
            BOOL isLiked = [[userActions objectForKey:@"likes"] integerValue] > 0;
            NSNumber *comments = [userActions objectForKey:@"comments"];
            NSLog(@"The user has %@ comments, liked=%d, total likes=%d, total comments=%d, total shares=%d", comments, isLiked, [entity likes], [entity comments], [entity shares]);
        }
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-print-stats-snippet


// begin-basic-meta-snippet

- (void)createEntityWithMeta {
    SZEntity *entity = [SZEntity entityWithKey:@"my_key" name:@"An Entity"];
    entity.meta = @"123";
    
    [SZEntityUtils addEntity:entity success:^(id<SZEntity> serverEntity) {
        NSLog(@"Created entity with meta %@", [serverEntity meta]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];

}

// end-basic-meta-snippet

// begin-json-meta-snippet

- (void)createEntityWithJSONMeta {
    SZEntity *entity = [SZEntity entityWithKey:@"my_key" name:@"An Entity"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"123" forKey:@"key"];
    entity.meta = [dictionary JSONString];
    
    [SZEntityUtils addEntity:entity success:^(id<SZEntity> serverEntity) {
        NSDictionary *retrievedDictionary = [[entity meta] objectFromJSONString];
        NSLog(@"Retrieved meta: %@", retrievedDictionary);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
    
}

// end-json-meta-snippet

// begin-custom-entity-page-snippet

- (void)createEntityWithCustomPageInfo {
    SZEntity *entity = [SZEntity entityWithKey:@"my_key" name:@"An Entity"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Some title for the page, if you don't want to use the entity name", @"szsd_title",
                            @"Description text on the page if there is no URL to parse", @"szsd_description",
                            @"http://the_url_to_your_thumbnail_image", @"szsd_thumb",
                            nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSAssert(error == nil, @"Error writing json: %@", [error localizedDescription]);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    entity.meta = jsonString;
    
    [SZEntityUtils addEntity:entity success:^(id<SZEntity> serverEntity) {
        NSLog(@"Successfully updated entity meta: %@", [serverEntity meta]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);        
    }];
}

// end-custom-entity-page-snippet

@end
