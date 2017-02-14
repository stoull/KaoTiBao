//
//  KTBUser.m
//  KaoTiBi
//
//  Created by Stoull Hut on 02/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBUser.h"

@implementation KTBUser
singleton_implementation(KTBUser)

- (instancetype)initWithUserInforDic:(NSDictionary *)infor{
    if (self = [super init]) {
        self.userId = [infor[@"id"] integerValue];
        self.address = infor[@"address"];
        self.age = [infor[@"age"] integerValue];
        self.birthday = infor[@"birthday"];
        self.contacts = infor[@"contacts"];
        self.descripteStr = infor[@"description"];
        self.email = infor[@"email"];
        self.enable = infor[@"enable"];
        self.errmsg = infor[@"errmsg"];
        self.experience = infor[@"experience"];
        self.gender = infor[@"gender"];
        self.grade = infor[@"grade"];
        self.hobby = infor[@"hobby"];
        self.job = infor[@"job"];
        self.lastLoggedLoc = infor[@"lastLoggedLoc"];
        self.lastLoggedTime = infor[@"lastLoggedTime"];
        self.level = [infor[@"level"] integerValue];
        self.loggedTimes = [infor[@"loggedTimes"] integerValue];
        self.maxSpace = [infor[@"maxSpace"] unsignedLongValue];
        self.name = infor[@"name"];
        self.organization = infor[@"organization"];
        self.password = infor[@"password"];
        self.phoneNumber = infor[@"phoneNumber"];
        self.portrait = infor[@"portrait"];
        self.portrait2 = infor[@"portrait2"];
        self.region = infor[@"region"];
        self.registerTime = infor[@"registerTime"];
        self.role = infor[@"role"];
        self.school = infor[@"school"];
        self.score = [infor[@"score"] integerValue];
        self.signature = infor[@"signature"];
        self.sms = infor[@"sms"];
        self.sns = infor[@"sns"];
        self.usedSpace = [infor[@"usedSpace"] unsignedLongValue];
        self.usedTime = [infor[@"usedTime"] integerValue];
        self.username = infor[@"username"];
        self.version = [infor[@"version"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:_userId forKey:@"id"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeInteger:_age forKey:@"age"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_contacts forKey:@"contacts"];
    [aCoder encodeObject:_descripteStr forKey:@"description"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeBool:_enable forKey:@"enable"];
    [aCoder encodeObject:_errmsg forKey:@"errmsg"];
    [aCoder encodeObject:_experience forKey:@"experience"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_grade forKey:@"grade"];
    [aCoder encodeObject:_hobby forKey:@"hobby"];
    [aCoder encodeObject:_job forKey:@"job"];
    [aCoder encodeObject:_lastLoggedLoc forKey:@"lastLoggedLoc"];
    [aCoder encodeObject:_lastLoggedTime forKey:@"lastLoggedTime"];
    [aCoder encodeInteger:_level forKey:@"level"];
    [aCoder encodeInteger:_loggedTimes forKey:@"loggedTimes"];
    [aCoder encodeDouble:_maxSpace forKey:@"maxSpace"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_organization forKey:@"organization"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:_portrait forKey:@"portrait"];
    [aCoder encodeObject:_portrait2 forKey:@"portrait2"];
    [aCoder encodeObject:_region forKey:@"region"];
    [aCoder encodeObject:_registerTime forKey:@"registerTime"];
    [aCoder encodeObject:_role forKey:@"role"];
    [aCoder encodeObject:_school forKey:@"school"];
    [aCoder encodeInteger:_score forKey:@"score"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_sms forKey:@"sms"];
    [aCoder encodeObject:_sns forKey:@"sns"];
    [aCoder encodeDouble:_usedSpace forKey:@"usedSpace"];
    [aCoder encodeInteger:_usedTime forKey:@"usedTime"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeInteger:_version forKey:@"version"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _userId =[aDecoder decodeIntegerForKey:@"id"];
        _address = [aDecoder decodeObjectForKey:@"address"];
        _age =[aDecoder decodeIntegerForKey:@"age"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _contacts = [aDecoder decodeObjectForKey:@"contacts"];
        _descripteStr = [aDecoder decodeObjectForKey:@"description"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _enable = [aDecoder decodeObjectForKey:@"enable"];
        _errmsg = [aDecoder decodeObjectForKey:@"errmsg"];
        _experience = [aDecoder decodeObjectForKey:@"experience"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _grade = [aDecoder decodeObjectForKey:@"grade"];
        _hobby = [aDecoder decodeObjectForKey:@"hobby"];
        _job = [aDecoder decodeObjectForKey:@"job"];
        _lastLoggedLoc = [aDecoder decodeObjectForKey:@"lastLoggedLoc"];
        _lastLoggedTime = [aDecoder decodeObjectForKey:@"lastLoggedTime"];
        _level =[aDecoder decodeIntegerForKey:@"level"];
        _loggedTimes =[aDecoder decodeIntegerForKey:@"loggedTimes"];
        _maxSpace =[aDecoder decodeDoubleForKey:@"maxSpace"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _organization = [aDecoder decodeObjectForKey:@"organization"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        _portrait = [aDecoder decodeObjectForKey:@"portrait"];
        _portrait2 = [aDecoder decodeObjectForKey:@"portrait2"];
        _region = [aDecoder decodeObjectForKey:@"region"];
        _registerTime = [aDecoder decodeObjectForKey:@"registerTime"];
        _role = [aDecoder decodeObjectForKey:@"role"];
        _school = [aDecoder decodeObjectForKey:@"school"];
        _score =[aDecoder decodeIntegerForKey:@"score"];
        _signature = [aDecoder decodeObjectForKey:@"signature"];
        _sms = [aDecoder decodeObjectForKey:@"sms"];
        _sns = [aDecoder decodeObjectForKey:@"sns"];
        _usedSpace =[aDecoder decodeDoubleForKey:@"usedSpace"];
        _usedTime =[aDecoder decodeIntegerForKey:@"usedTime"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _version =[aDecoder decodeIntegerForKey:@"version"];
    }
    return self;
}



@end
