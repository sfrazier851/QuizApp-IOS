//
//  SQLiteConfig.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/14/22.
//

import Foundation

class SQLiteTables {
   
   static var BEGIN = "BEGIN TRANSACTION;"
   static var COMMIT = "COMMIT TRANSACTION;"
    
   private static var dropUserTable = "DROP TABLE IF EXISTS User;"
   private static var createUserTable = """
             CREATE TABLE IF NOT EXISTS User \
             (ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, \
             username TEXT NOT NULL, \
             email TEXT NOT NULL, \
             password TEXT NOT NULL, \
             is_loggedin BOOLEAN DEFAULT 0 NOT NULL CHECK (is_loggedin IN (0, 1)), \
             is_blocked BOOLEAN DEFAULT 0 NOT NULL CHECK (is_blocked IN (0, 1)), \
             is_subscribed BOOLEAN DEFAULT 0 NOT NULL CHECK (is_subscribed IN (0, 1)), \
             is_admin BOOLEAN DEFAULT 0 NOT NULL CHECK (is_admin IN (0, 1)), \
             app_feedback TEXT DEFAULT "" NOT NULL);
             """
    private static var insertIntoUserTable = """
             INSERT INTO User ( username, email, password, is_loggedin, is_blocked, is_subscribed, is_admin, app_feedback ) \
             VALUES ('tester1', 't1@gmail.com', 'Password!', 0, 0, 0, 0, 'great app, love it!'),
             ('gary', 'gary@gmail.com', 'Gassword!', 0, 0, 0, 0, ''),
             ('admin', 'admin@gmail.com', 'superSecret!', 0, 0, 0, 1, '');
             """
    static var userTableScripts = [dropUserTable, createUserTable, insertIntoUserTable]
    
    
    
    private static var dropQuizTable = "DROP TABLE IF EXISTS Quiz;"
    private static var createQuizTable = """
             CREATE TABLE IF NOT EXISTS Quiz \
             (ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, \
             name TEXT NOT NULL);
             """
    private static var insertIntoQuizTable = """
             INSERT INTO Quiz ( name ) \
             VALUES ( 'Java' ), ( 'Android' ), ( 'iOS');
             """
    static var quizTableScripts = [dropQuizTable, createQuizTable, insertIntoQuizTable]
    
    
    
    private static var dropQuestionAnswerTable = "DROP TABLE IF EXISTS QuestionAnswer;"
    private static var createQuestionAnswerTable = """
             CREATE TABLE IF NOT EXISTS QuestionAnswer \
             (ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, \
             quizID INTEGER NOT NULL, \
             question TEXT NOT NULL, \
             answer TEXT NOT NULL, \
             wrong_options TEXT NOT NULL, \
             FOREIGN KEY(quizID) REFERENCES Quiz(ID));
             """
    private static var insertIntoQuestionAnswerTable = """
             INSERT INTO QuestionAnswer ( quizID, question, answer, wrong_options) \
             VALUES ( 1, 'What is Java?', 'Java is a high-level, class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible.', 'A type of coffee.;An island that is part of Indonesia.;A type of computer.'),
             ( 1, 'Is Java strongly-typed?', 'Yes', 'No;Yes, but only for primitive types.;Yes, but only for Generic types.');
             """
    static var questionAnswerTableScripts = [dropQuestionAnswerTable, createQuestionAnswerTable, insertIntoQuestionAnswerTable]
    
    
    
    private static var dropQuizAttemptTable = "DROP TABLE IF EXISTS QuizAttempt;"
    private static var createQuizAttemptTable = """
             CREATE TABLE IF NOT EXISTS QuizAttempt \
             (ID INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, \
             userID INTEGER NOT NULL, \
             quizID INTEGER NOT NULL, \
             score DECIMAL(10,2) NOT NULL, \
             date_attempted TEXT DEFAULT (date()) NOT NULL, \
             FOREIGN KEY(userID) REFERENCES User(ID), \
             FOREIGN KEY(quizID) REFERENCES Quiz(ID));
             """
    private static var insertIntoQuizAttemptTable = """
             INSERT INTO QuizAttempt ( userID, quizID, score ) \
             VALUES ( 1, 1, 0.95 ), \
             ( 2, 1, 0.60 );
             """
    static var quizAttemptTableScripts = [dropQuizAttemptTable, createQuizAttemptTable, insertIntoQuizAttemptTable]
}
