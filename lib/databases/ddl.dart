String recordDDL =
    'CREATE TABLE records(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updateAt TIMESTAMP DEFAULT NULL, isDelete INTEGER DEFAULT 0, isFavorite INTEGER DEFAULT 0, replyCount INTEGER DEFAULT 0)';
String contributionDDL =
    'CREATE TABLE contributions(id INTEGER PRIMARY KEY AUTOINCREMENT, year TEXT, month TEXT, day TEXT, count INT, lastUpdateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP)';