//
//  constants.m
//  runsignup_mobile
//
//  Created by James Harris on 10/18/17.
//  Copyright © 2017 BICKEL ADVISORY SERVICES LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// RSU ENTRY POINT PRODUCTION
//#define RSU_DOMAIN  @"runsignup.com"
//#define RSU_ENTRY_POINT_SERVER_URL  @"https://runsignup.com/MobileRaces"

// Testing Entry Point: jk local: localhost
//#define RSU_DOMAIN  @"http://localhost"
//#define RSU_ENTRY_POINT_SERVER_URL  @"http://localhost/MobileRaces"

// Testing Entry Point: jk local: 10.1.10.68
//#define RSU_DOMAIN  @"10.1.10.68"
//#define RSU_ENTRY_POINT_SERVER_URL  @"http://10.1.10.68/MobileRaces"

// Testing Entry Point: jk home local: 10.0.0.21
//#define RSU_DOMAIN  @"10.0.0.21"
//#define RSU_ENTRY_POINT_SERVER_URL  @"http://10.0.0.21/MobileRaces"

// Testing Entry Point: local: hosts file redirects test.runsignup.com to 10.1.10.68
//#define RSU_DOMAIN  @"test.runsignup.com"
//#define RSU_ENTRY_POINT_SERVER_URL  @"http://test.runsignup.com/MobileRaces"

// jh local
//#define RSU_DOMAIN  @"192.168.0.9"
//#define RSU_ENTRY_POINT_SERVER_URL  @"http://192.168.0.9:8082"

// TESTING ENTRY POINT: test4.runsignup.com
#define RSU_DOMAIN  @"test4.runsignup.com"
#define RSU_ENTRY_POINT_SERVER_URL  @"http://test4.runsignup.com/MobileRaces"

#define RSU_URL_PROTOCOL_KEY   @"RSUURLProtocolHandledKey"

// Custom Header Fields
#define CUSTOM_USER_AGENT   @" iOS_RSU_MOBILE_TYPE"
#define CUSTOM_HEADER_MOBILE_TYPE_FIELDNAME   @"x-rsu-mobile-type"
#define CUSTOM_HEADER_MOBILE_TYPE_FIELDVALUE  @"ios"

