//
//  MyFMDataBase.m
//  FMDataBaseDemo
//
//  Created by 黄嘉宏 on 15/9/6.
//  Copyright (c) 2015年 黄嘉宏. All rights reserved.
//

#import "MyFMDataBase.h"


@interface MyFMDataBase ()

//全局声明数据库dataBase
@property(nonatomic,strong)FMDatabase *dataBase;

@end

@implementation MyFMDataBase

+(MyFMDataBase *)shareMyFMDataBase{
    static MyFMDataBase * _manager;
    if (_manager == nil) {
        _manager = [[MyFMDataBase alloc]init];
    }
    
    ZYUserManager * user = [ZYUserManager fileUserManager];

    if ([_manager createDataBaseWithDataBaseName:user.user_sip]){
        //创建表单
        //勿扰模式列表
        [_manager createTableWithTableName:DontDisturbInfo tableArray:DontDisturbInfoDic];
    }

    
    
    return _manager;
}

#pragma mark - 创建一个数据库
-(BOOL)createDataBaseWithDataBaseName:(NSString *)dbName{
    @synchronized(self) {
    
        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.sqlite",NSHomeDirectory(),dbName];
        
        self.dataBase = [[FMDatabase alloc]initWithPath:filePath];
        
        //把数据库打开
        if (self.dataBase.open) {
            SYLog(@"自己建立的数据库打开成功  路径：%@",filePath);
            return YES;
        }
        else{
            SYLog(@"自己建立的数据库打开失败  路径：%@",filePath);
            return NO;
        }

    }
}

#pragma mark - 创建一个表单
-(void)createTableWithTableName:(NSString *)tableName tableArray:(NSArray *)tableArray{

    NSString *scutureString = @"";
    
    for (NSString *stringKey in tableArray) {
        scutureString = [NSString stringWithFormat:@"%@%@ varchar(32),",scutureString,stringKey];
    }
    
    NSString *scutureString2 = [scutureString substringToIndex:scutureString.length - 1];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,scutureString2];
    
    
//    SYLog(@"创建表单语句 === %@",sql);
    
    //通过dataBase使用sql语句
    @synchronized(self) {
       BOOL isCreate = [self.dataBase executeUpdate:sql];
        if (isCreate) {
            SYLog(@"创建表单成功  表单名称 %@",tableName);
        }
        else{
            SYLog(@"创建表单失败  表单名称 %@",tableName);
        }
    }
  
}

#pragma mark - insert插入数据
-(void)insertDataWithTableName:(NSString *)tableName insertDictionary:(NSDictionary *)insertDictionary{

    NSString *scutureString = @"";
    
    for (NSString *keyString in insertDictionary.allKeys) {
        scutureString = [NSString stringWithFormat:@"%@,%@",scutureString,keyString];
    }
    NSString *scutureString2 = [scutureString substringFromIndex:1];
    
    //值字符串
    //字段名字符串
    NSString *valueString = @"";
    
    for (NSString *keyString in insertDictionary.allKeys) {
        valueString = [NSString stringWithFormat:@"%@,'%@'",valueString,insertDictionary[keyString]];
    }
    NSString *valueString2 = [valueString substringFromIndex:1];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",tableName,scutureString2,valueString2];
    
//    SYLog(@"插入语句 ===   %@",sql);
    
    BOOL isInsert = [self.dataBase executeUpdate:sql];
    
    if (isInsert) {
        SYLog(@"插入sql数据成功");
    }
    else{
        SYLog(@"插入sql数据失败");
    }
}

#pragma mark - 修改表单中的数据
-(void)updateDataWithTableName:(NSString *)tableName updateDictionary:(NSDictionary *)updateArray whereArray:(NSDictionary *)whereArray{
    
    //拼接需要改变的字段名
    NSString *setString = @"";
    int i = 0;
    for (NSString *keyString in updateArray.allKeys) {
        setString = [NSString stringWithFormat:@"%@ = '%@',",keyString,updateArray[updateArray.allKeys[i]]];
        i++;
    }
    NSString *setString2 = [setString substringToIndex:setString.length - 1];
    
    //拼接条件字段名
    NSString *whereString = @"";
    int j = 0;
    for (NSString *keyString in whereArray.allKeys) {
        whereString = [NSString stringWithFormat:@"%@ = '%@',",keyString,whereArray[whereArray.allKeys[j]]];
        j++;
    }
    NSString *whereString2 = [whereString substringToIndex:whereString.length - 1];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,setString2,whereString2];
    
//    SYLog(@"修改表达内容语句 === %@",sql);
    
    //修改某个数据
    @synchronized(self) {

    BOOL isUpdate = [self.dataBase executeUpdate:sql];
    
        if (isUpdate) {
            SYLog(@"修改数据成功");
        }
        else{
            SYLog(@"修改数据失败");
        }

    }
}

#pragma mark - deleteData删除操作
-(void)deleteDataWithTableName:(NSString *)tableName delegeteDic:(NSDictionary *)delegeteDic{

    NSString *sql = @"";
    
    if (!delegeteDic) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    }
    else{
        NSString *whereString = @"";
        int j = 0;
        for (NSString *keyString in delegeteDic.allKeys) {
            whereString = [whereString stringByAppendingFormat:@"%@ = '%@' and ",keyString,delegeteDic[delegeteDic.allKeys[j]]];
            j++;
            NSLog(@"wherestr  ==  %@",whereString);
        }
        NSString *whereString2 = [whereString substringToIndex:whereString.length - 4];
        
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,whereString2];
    }
    
    
//    SYLog(@"删除表单内容语句 === %@",sql);
    
    @synchronized(self) {
        BOOL isDelete = [self.dataBase executeUpdate:sql];
        
        if (isDelete) {
            NSLog(@"删除该数据成功");
        }
        else{
            NSLog(@"删除该数据失败");
        }
        
    }
}

#pragma mark - 查询数据表中的数据 筛选条件
-(NSArray *)selectDataWithTableName:(NSString *)tableName withDic:(NSDictionary *)selecDic{
    //sql的查询语句
    //拼接条件字段名
    NSString *whereString = @"";
    NSString *whereString2 = @"";
    if (selecDic) {
        
        for (NSString * keyString in selecDic.allKeys) {
            whereString = [NSString stringWithFormat:@"%@%@ = '%@' and ",whereString,keyString,selecDic[keyString]];
            
        }
        whereString2 = [whereString substringToIndex:whereString.length - 4];
    }
    
//    SYLog(@"whereString2 ==== %@",whereString2);
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ",tableName,whereString2];
    
    if (!selecDic || selecDic.count == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    }
    
    
//    SYLog(@"选择内容语句 === %@",sql);
    @synchronized(self) {
    NSMutableArray * mArr = [NSMutableArray array];
    FMResultSet *result = [self.dataBase executeQuery:sql];
    while ([result next]) {
        
        //勿扰模式
        if ([tableName isEqualToString:DontDisturbInfo]) {
            NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
            [mdic setObject:[result stringForColumn:@"isDontDisturb"] forKey:@"isDontDisturb"];
            [mdic setObject:[result stringForColumn:@"statTime"] forKey:@"statTime"];
            [mdic setObject:[result stringForColumn:@"endTime"] forKey:@"endTime"];
            [mArr addObject:mdic];
        }
    }
    
    return mArr;
    }
}

#pragma mark - 关闭数据库
-(void)closeDataBase{
    //关闭数据库
    @synchronized(self) {
        
        BOOL isClose = [self.dataBase close];
        
        if (isClose) {
            SYLog(@"关闭数据库成功");
        }
        else{
            SYLog(@"关闭数据库失败");
        }
    }
}


@end
