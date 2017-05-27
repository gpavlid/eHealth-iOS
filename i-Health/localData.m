//
//  localData.m
//  i-Health
//
//  Created by gpavlid on 10/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import "localData.h"
#import "debug.h"


@implementation localData


-(void)loadData {

	sqlite3_stmt *statement;
	const char *dbpath = [_databasePath UTF8String];

	if (sqlite3_open(dbpath, &_dataDB) == SQLITE_OK) {

		NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM data WHERE name=\"%@\"",_name];
		const char *query_stmt = [querySQL UTF8String];

		if (sqlite3_prepare_v2(_dataDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {

			while (sqlite3_step(statement) == SQLITE_ROW) {

				NSDate *dateField = [[NSDate alloc] initWithTimeIntervalSince1970:sqlite3_column_double(statement, 1)];
				_moment = dateField;
				NSString *nameField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
				_name = nameField;
				NSString *valueField = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
				_value = valueField;
				NSString *metricField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
				_metric = metricField;
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(_dataDB);
	}

}


-(void)saveData {

	sqlite3_stmt *statement;
	const char *dbpath = [_databasePath UTF8String];
/*
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
*/	
	// probably needs the "/1000" part as it returns milliseconds...
	double dateDouble = [[NSDate date] timeIntervalSince1970]/1000;
	
	if (sqlite3_open(dbpath, &_dataDB) == SQLITE_OK) {
		NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO DATA (moment, name, value, metric) VALUES (\"%f\", \"%@\", \"%@\", \"%@\")", dateDouble, _name, _value, _metric];

		const char *insert_stmt = [insertSQL UTF8String];
		sqlite3_prepare_v2(_dataDB, insert_stmt, -1, &statement, NULL);
//		sqlite3_bind_text(statement, 1, [dateString UTF8String] , -1, SQLITE_TRANSIENT);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			_status = @"Data added!";
		} else {
			_status = @"Failed to add data!";
		}
		sqlite3_finalize(statement);
		sqlite3_close(_dataDB);
	}

	if(iHealthDebug) NSLog(@"DB Status: %@",_status);

}



-(void)initializeLocalData {

	NSString *docsDir;
	NSArray *dirPaths;

	// Get the documents directory
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = dirPaths[0];

	// Build the path to the database file
	_databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"iHealth.db"]];

	// initialize a file manager
	NSFileManager *filemgr = [NSFileManager defaultManager];
	if ([filemgr fileExistsAtPath: _databasePath ] == NO) {
		const char *dbpath = [_databasePath UTF8String];
		if (sqlite3_open(dbpath, &_dataDB) == SQLITE_OK) {
			char *errMsg;
			const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DATA (ID INTEGER PRIMARY KEY AUTOINCREMENT, MOMENT DOUBLE NAME TEXT, VALUE TEXT, METRIC TEXT)";

			if (sqlite3_exec(_dataDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
				_status = @"Failed to create table";
			}
			sqlite3_close(_dataDB);
		} else {
			_status = @"Failed to open/create database";
		}
	}
	
	if(iHealthDebug) NSLog(@"DB Status: %@",_status);
	
}


@end
