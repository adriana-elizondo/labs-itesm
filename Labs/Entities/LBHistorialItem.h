//
//  LBHistorialItem.h
//  Labs
//
//  Created by alumno on 10/15/15.
//  Copyright (c) 2015 ITESM. All rights reserved.
//

#import "JSONModel.h"

@interface LBHistorialItem : JSONModel
@property NSString *id_history;
@property NSString *date_out;
@property NSString *id_student_fk;
@property NSString *id_component_fk;
@property NSString *quantity;
@property NSString <Optional>*date_in;
@property NSString <Ignore>*componentName;
@property NSString <Ignore>*categoryName;
@end
